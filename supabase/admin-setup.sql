-- Lista de convidados — execute no SQL Editor do Supabase
-- Resultado esperado: a query final deve listar as policies da tabela rsvps

-- 1) Policy de leitura para usuários logados (o casal)
drop policy if exists "rsvps_select_authenticated" on public.rsvps;
create policy "rsvps_select_authenticated"
  on public.rsvps for select
  to authenticated
  using (true);

-- 2) Garantir permissão de SELECT no papel authenticated
grant usage on schema public to authenticated;
grant select on table public.rsvps to authenticated;

-- 3) Verificação — deve aparecer pelo menos 2 policies (insert anon + select authenticated)
select
  policyname as policy,
  roles::text as roles,
  cmd as operacao
from pg_policies
where schemaname = 'public' and tablename = 'rsvps'
order by policyname;
