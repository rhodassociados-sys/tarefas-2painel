// Monta a pasta public/ (index.html + config.js) a partir das variáveis de ambiente.
// Na Vercel, defina SUPABASE_URL e SUPABASE_ANON_KEY em Settings > Environment Variables.
// Localmente, coloque as duas em um arquivo .env.local (veja .env.example).
import { copyFileSync, existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";

function lerEnvLocal() {
  if (!existsSync(".env.local")) return {};
  const out = {};
  for (const linha of readFileSync(".env.local", "utf8").split(/\r?\n/)) {
    const m = linha.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*?)\s*$/);
    if (m) out[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
  return out;
}

const local = lerEnvLocal();
const url = (process.env.SUPABASE_URL || local.SUPABASE_URL || "").trim();
const key = (process.env.SUPABASE_ANON_KEY || local.SUPABASE_ANON_KEY || "").trim();

if (!/^https:\/\/[a-z0-9-]+\.supabase\.co\/?$/i.test(url)) {
  console.error("SUPABASE_URL ausente ou inválida. Exemplo: https://abcdxyz.supabase.co");
  process.exit(1);
}
if (key.length < 20) {
  console.error("SUPABASE_ANON_KEY ausente. Use a chave anon/publishable do projeto.");
  process.exit(1);
}
if (key.startsWith("sb_secret_") || /service_role/i.test(key)) {
  console.error("Essa parece ser a chave secreta (service_role). Use apenas a chave anon/publishable.");
  process.exit(1);
}
try {
  const payload = JSON.parse(Buffer.from(key.split(".")[1] || "", "base64url").toString("utf8"));
  if (payload.role === "service_role") {
    console.error("Essa chave tem papel service_role. Use apenas a chave anon.");
    process.exit(1);
  }
} catch {
  // chaves no formato novo (sb_publishable_...) não são JWT; segue normalmente
}

mkdirSync("public", { recursive: true });
copyFileSync("index.html", "public/index.html");
writeFileSync(
  "public/config.js",
  "window.APP_CONFIG = " + JSON.stringify({ SUPABASE_URL: url.replace(/\/$/, ""), SUPABASE_ANON_KEY: key }) + ";\n"
);
console.log("public/ montada (index.html + config.js).");
