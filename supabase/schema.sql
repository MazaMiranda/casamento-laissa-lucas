-- Execute no Supabase: SQL Editor → New query → Run
-- Projeto: casamento-laissa-lucas

-- RSVP (confirmação de presença)
create table if not exists public.rsvps (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  email text not null,
  telefone text,
  presenca text not null check (presenca in ('sim', 'nao', 'talvez')),
  adultos integer not null default 1 check (adultos >= 0),
  criancas integer not null default 0 check (criancas >= 0),
  observacoes text,
  created_at timestamptz not null default now()
);

-- Recados dos convidados
create table if not exists public.recados (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  email text,
  recado text not null,
  created_at timestamptz not null default now()
);

create index if not exists rsvps_created_at_idx on public.rsvps (created_at desc);
create index if not exists rsvps_presenca_idx on public.rsvps (presenca);
create index if not exists recados_created_at_idx on public.recados (created_at desc);

alter table public.rsvps enable row level security;
alter table public.recados enable row level security;

-- Site: convidados podem enviar RSVP
drop policy if exists "rsvps_insert_anon" on public.rsvps;
create policy "rsvps_insert_anon"
  on public.rsvps for insert
  to anon
  with check (true);

-- Site: convidados podem enviar recados
drop policy if exists "recados_insert_anon" on public.recados;
create policy "recados_insert_anon"
  on public.recados for insert
  to anon
  with check (true);

-- Site: recados visíveis publicamente na página
drop policy if exists "recados_select_anon" on public.recados;
create policy "recados_select_anon"
  on public.recados for select
  to anon
  using (true);

-- RSVPs: leitura apenas via service role ou app autenticado (lista de convidados)
drop policy if exists "rsvps_select_authenticated" on public.rsvps;
create policy "rsvps_select_authenticated"
  on public.rsvps for select
  to authenticated
  using (true);

grant usage on schema public to authenticated;
grant select on table public.rsvps to authenticated;

-- Crie os usuários do casal em: Authentication → Users → Add user (e-mail + senha)
-- Verificar policies: select policyname, roles, cmd from pg_policies where tablename = 'rsvps';
