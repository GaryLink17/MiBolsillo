-- Mi Bolsillo · Ajuste de la vista de saldos (M2.5)
--
-- La vista creada en `0001_init.sql` expone `initial_balance`, pero en la base
-- ya desplegada quedó una versión anterior sin esa columna. El cálculo del
-- saldo es correcto; este script solo alinea las columnas.
--
-- Cómo aplicarlo:
--   1. Supabase → SQL Editor → New query
--   2. Pega todo este archivo y pulsa Run UNA sola vez.

drop view if exists public.account_balances;

create view public.account_balances
with (security_invoker = true) as
select
  a.id,
  a.user_id,
  a.name,
  a.kind,
  a.is_archived,
  a.initial_balance
    + coalesce(sum(
        case m.type
          when 'ingreso' then m.amount 
          when 'gasto' then -m.amount
          when 'ahorro' then -m.amount
        end
      ), 0) as balance
from public.accounts a
left join public.movements m on m.account_id = a.id
group by a.id;

grant select on public.account_balances to authenticated;
revoke all on public.account_balances from anon;
