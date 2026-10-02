# Painel de Pendências

Gestão de pendências por cliente: responsável, prazo, prioridade, status, métricas de atraso e carga por pessoa. Site estático (HTML + JavaScript) com dados e login na Supabase, publicado na Vercel.

## Como funciona

- `index.html`: o painel inteiro, sem framework.
- `build.mjs`: na hora do deploy, monta a pasta `public/` com o `index.html` e um `config.js` com a URL e a chave **anon** da Supabase (vindas das variáveis de ambiente).
- `schema.sql`: cria as tabelas `clientes` e `tarefas`, liga a segurança por linha e o tempo real.
- `seed.sql`: carrega o cliente Pórtico com as 11 pendências.

A chave anon fica visível no navegador, o que é normal na Supabase. Quem protege os dados é o login: sem entrar, as tabelas não devolvem nada.

## 1. Supabase

1. Crie um projeto (ou use o que já tem) em supabase.com.
2. Abra **SQL Editor**, cole o conteúdo de `schema.sql` e execute.
3. Cole o conteúdo de `seed.sql` e execute (opcional, traz a Pórtico).
4. Em **Authentication > Users > Add user**, crie um usuário com e-mail e senha para cada pessoa que vai usar (você, Jonathan, Marco, Louzada). Marque "Auto confirm user".
5. Em **Authentication > Sign In / Providers**, desligue **Allow new users to sign up**. Assim só entra quem você criou.
6. Em **Project Settings > API**, copie a **Project URL** e a chave **anon / publishable**. Não use a `service_role` nem a `secret`.

Todo usuário logado enxerga todos os clientes. Se algum dia você quiser que alguém veja só um cliente, é preciso trocar as políticas do `schema.sql`.

## 2. GitHub

Na pasta do projeto:

```bash
git init
git add .
git commit -m "Painel de Pendências"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/painel-pendencias.git
git push -u origin main
```

Crie o repositório vazio antes, como **privado**, em github.com/new. O `.gitignore` já impede que `.env` e `config.js` subam.

## 3. Vercel

1. Em vercel.com, **Add New > Project** e importe o repositório.
2. Framework Preset: **Other**. O `vercel.json` já define o build e a pasta `public`.
3. Em **Environment Variables**, cadastre:
   - `SUPABASE_URL` = a Project URL
   - `SUPABASE_ANON_KEY` = a chave anon
4. **Deploy**. Abra o endereço, entre com um dos usuários criados no passo 1.

Se o build falhar com "SUPABASE_URL ausente", as variáveis não foram salvas para o ambiente Production.

## Testar no seu computador

```bash
cp .env.example .env.local   # preencha as duas variáveis
npm run dev
```

## Mudar a estrutura depois

Para novas categorias, status ou campos, edite as listas no início do script em `index.html` e, se for um campo novo, adicione a coluna no Supabase. Cada push na branch `main` publica sozinho.
