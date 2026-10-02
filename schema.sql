-- Painel de Pendências: tabelas, segurança e tempo real.
-- Rode uma vez em Supabase > SQL Editor. Pode rodar de novo sem duplicar nada.

create table if not exists public.clientes (
  id         text primary key,
  nome       text not null,
  criado_em  timestamptz not null default now()
);

create table if not exists public.tarefas (
  id               text primary key default gen_random_uuid()::text,
  cliente          text not null references public.clientes(id) on delete cascade,
  titulo           text not null,
  acao             text not null default '',
  responsavel      text not null default '',
  prazo            date,
  prioridade       text not null default 'Média'   check (prioridade in ('Alta', 'Média', 'Baixa')),
  status           text not null default 'A fazer' check (status in ('A fazer', 'Em andamento', 'Aguardando', 'Concluída')),
  categoria        text not null default '',
  recorrencia      text not null default ''        check (recorrencia in ('', 'Diária', 'Semanal', 'Mensal')),
  notas            text not null default '',
  criado_em        timestamptz not null default now(),
  concluido_em     date,
  ultima_execucao  date
);

create index if not exists tarefas_cliente_idx on public.tarefas (cliente);
create index if not exists tarefas_status_idx  on public.tarefas (status);

-- Segurança: só quem fez login lê e escreve. Quem não está logado não vê nada.
alter table public.clientes enable row level security;
alter table public.tarefas  enable row level security;

drop policy if exists "equipe acessa clientes" on public.clientes;
create policy "equipe acessa clientes" on public.clientes
  for all to authenticated using (true) with check (true);

drop policy if exists "equipe acessa tarefas" on public.tarefas;
create policy "equipe acessa tarefas" on public.tarefas
  for all to authenticated using (true) with check (true);

-- Tempo real: quando um usuário altera uma pendência, os outros veem na hora.
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'clientes') then
    alter publication supabase_realtime add table public.clientes;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'tarefas') then
    alter publication supabase_realtime add table public.tarefas;
  end if;
end $$;
