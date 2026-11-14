-- Captura conjunta de cuentas y metas activas para consulta offline.
--
-- Las dos listas se calculan en una sola sentencia y por tanto comparten la
-- misma instantánea de PostgreSQL. Los importes viajan como texto decimal para
-- que el cliente pueda convertirlos a centavos sin pasar por punto flotante.
--
-- SECURITY INVOKER conserva los permisos y las políticas RLS del usuario; no
-- usa service_role. La función aún debe aplicarse y probarse antes de usarse.

create or replace function public.balance_snapshot()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select pg_catalog.jsonb_build_object(
    'accounts', coalesce(
      (
        select pg_catalog.jsonb_agg(
          pg_catalog.jsonb_build_object(
            'id', b.id,
            'name', b.name,
            'kind', b.kind,
            'balance', b.balance::text
          ) order by a.created_at, a.id
        )
        from public.account_balances b
        join public.accounts a on a.id = b.id and a.user_id = b.user_id
        where b.user_id = (select auth.uid()) and not b.is_archived
      ),
      '[]'::jsonb
    ),
    'goals', coalesce(
      (
        select pg_catalog.jsonb_agg(
          pg_catalog.jsonb_build_object(
            'id', g.id,
            'name', g.name,
            'target_amount', g.target_amount::text,
            'target_date', g.target_date,
            'saved', g.saved::text
          ) order by g.name, g.id
        )
        from public.goal_balances g
        where g.user_id = (select auth.uid()) and not g.is_archived
      ),
      '[]'::jsonb
    )
  );
$$;

revoke all on function public.balance_snapshot() from public, anon;
grant execute on function public.balance_snapshot() to authenticated;
