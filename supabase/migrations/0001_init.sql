-- Mi Bolsillo · Esquema inicial (M2.2)
--
-- Cómo aplicarlo:
--   1. Supabase → SQL Editor → New query
--   2. Pega todo este archivo y pulsa Run UNA sola vez.
--   3. Revisa en Table Editor que aparezcan las 5 tablas y sus políticas.
--
-- El script es idempotente en lo posible: si algo falla a la mitad, puedes
-- corregirlo y volver a ejecutarlo sin duplicar datos.

-- ---------------------------------------------------------------------------
-- 0. Extensiones y tipos
-- ---------------------------------------------------------------------------

create extension if not exists pgcrypto;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'account_kind') then
    create type public.account_kind as enum
      ('efectivo', 'banco', 'ahorro', 'tarjeta', 'otro');
  end if;
end
$$;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'category_kind') then
    create type public.category_kind as enum ('gasto', 'ingreso');
  end if;
end
$$;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'movement_type') then
    create type public.movement_type as enum ('gasto', 'ingreso', 'ahorro');
  end if;
end
$$;

-- ---------------------------------------------------------------------------
-- 1. Perfiles (uno por usuario de auth.users)
-- ---------------------------------------------------------------------------

create table if not exists public.profiles (
  id         uuid primary key references auth.users (id) on delete cascade,
  full_name  text,
  currency   text not null default 'DOP' check (currency = 'DOP'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.profiles is 'Datos del usuario. Se crea solo al registrarse.';

-- ---------------------------------------------------------------------------
-- 2. Cuentas
-- ---------------------------------------------------------------------------

create table if not exists public.accounts (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  name            text not null check (length(trim(name)) between 1 and 60),
  kind            public.account_kind not null default 'banco',
  initial_balance numeric(14, 2) not null default 0,
  icon            text,
  is_archived     boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

comment on column public.accounts.initial_balance is
  'Dinero con el que el usuario empieza en esa cuenta. Sí cuenta en el balance total.';

-- ---------------------------------------------------------------------------
-- 3. Categorías
-- ---------------------------------------------------------------------------

create table if not exists public.categories (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  name        text not null check (length(trim(name)) between 1 and 40),
  kind        public.category_kind not null,
  tone        text not null default 'other',
  icon        text not null default 'other',
  is_archived boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Una misma persona no puede tener dos categorías con el mismo nombre y tipo.
create unique index if not exists categories_user_name_kind_idx
  on public.categories (user_id, lower(name), kind);

-- ---------------------------------------------------------------------------
-- 4. Metas de ahorro
-- ---------------------------------------------------------------------------

create table if not exists public.goals (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles (id) on delete cascade,
  name          text not null check (length(trim(name)) between 1 and 60),
  target_amount numeric(14, 2) not null check (target_amount > 0),
  target_date   date,
  tone          text not null default 'health',
  icon          text not null default 'flag',
  is_archived   boolean not null default false,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 5. Movimientos (gasto, ingreso y ahorro)
-- ---------------------------------------------------------------------------

create table if not exists public.movements (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  type        public.movement_type not null,
  amount      numeric(14, 2) not null check (amount > 0),
  occurred_on date not null default current_date,
  account_id  uuid not null references public.accounts (id) on delete restrict,
  category_id uuid references public.categories (id) on delete set null,
  goal_id     uuid references public.goals (id) on delete restrict,
  note        text check (length(note) <= 200),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),

  -- Ahorro: siempre va a una meta y nunca tiene categoría.
  -- Gasto e ingreso: nunca van a una meta.
  constraint movement_destination check (
    (type = 'ahorro' and goal_id is not null and category_id is null)
    or (type <> 'ahorro' and goal_id is null)
  )
);

comment on table public.movements is
  'Un ahorro descuenta de la cuenta y suma a la meta: el balance total no cambia.';

-- Índices para listas, reportes y llaves foráneas.
create index if not exists movements_user_date_idx
  on public.movements (user_id, occurred_on desc);
create index if not exists movements_account_idx
  on public.movements (account_id);
create index if not exists movements_category_idx
  on public.movements (category_id);
create index if not exists movements_goal_idx
  on public.movements (goal_id);
create index if not exists accounts_user_idx
  on public.accounts (user_id);
create index if not exists goals_user_idx
  on public.goals (user_id);

-- ---------------------------------------------------------------------------
-- 6. Vistas de saldos (solo lectura, respetan RLS)
-- ---------------------------------------------------------------------------

create or replace view public.account_balances
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

create or replace view public.goal_balances
with (security_invoker = true) as
select
  g.id,
  g.user_id,
  g.name,
  g.target_amount,
  g.target_date,
  g.is_archived,
  coalesce(sum(m.amount), 0) as saved
from public.goals g
left join public.movements m
  on m.goal_id = g.id and m.type = 'ahorro'
group by g.id;

-- ---------------------------------------------------------------------------
-- 7. updated_at automático
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

drop trigger if exists accounts_set_updated_at on public.accounts;
create trigger accounts_set_updated_at
  before update on public.accounts
  for each row execute function public.set_updated_at();

drop trigger if exists categories_set_updated_at on public.categories;
create trigger categories_set_updated_at
  before update on public.categories
  for each row execute function public.set_updated_at();

drop trigger if exists goals_set_updated_at on public.goals;
create trigger goals_set_updated_at
  before update on public.goals
  for each row execute function public.set_updated_at();

drop trigger if exists movements_set_updated_at on public.movements;
create trigger movements_set_updated_at
  before update on public.movements
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 8. Alta automática: perfil + categorías básicas
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''))
  on conflict (id) do nothing;

  insert into public.categories (user_id, name, kind, tone, icon) values
    (new.id, 'Comida',     'gasto',   'food',      'restaurant'),
    (new.id, 'Transporte', 'gasto',   'transport', 'directions_car'),
    (new.id, 'Hogar',      'gasto',   'home',      'home'),
    (new.id, 'Ocio',       'gasto',   'leisure',   'celebration'),
    (new.id, 'Salud',      'gasto',   'health',    'health_and_safety'),
    (new.id, 'Otros',      'gasto',   'other',     'category'),
    (new.id, 'Salario',    'ingreso', 'income',    'payments')
  on conflict do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- 9. Seguridad: RLS y permisos
-- ---------------------------------------------------------------------------

alter table public.profiles   enable row level security;
alter table public.accounts   enable row level security;
alter table public.categories enable row level security;
alter table public.goals      enable row level security;
alter table public.movements  enable row level security;

drop policy if exists "perfil propio" on public.profiles;
create policy "perfil propio" on public.profiles
  for all
  to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

drop policy if exists "mis cuentas" on public.accounts;
create policy "mis cuentas" on public.accounts
  for all
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "mis categorias" on public.categories;
create policy "mis categorias" on public.categories
  for all
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "mis metas" on public.goals;
create policy "mis metas" on public.goals
  for all
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "mis movimientos" on public.movements;
create policy "mis movimientos" on public.movements
  for all
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Los usuarios anónimos no ven nada; solo la app autenticada.
revoke all on public.profiles        from anon;
revoke all on public.accounts        from anon;
revoke all on public.categories      from anon;
revoke all on public.goals           from anon;
revoke all on public.movements       from anon;
revoke all on public.account_balances from anon;
revoke all on public.goal_balances    from anon;

grant select, insert, update         on public.profiles        to authenticated;
grant select, insert, update, delete on public.accounts        to authenticated;
grant select, insert, update, delete on public.categories      to authenticated;
grant select, insert, update, delete on public.goals           to authenticated;
grant select, insert, update, delete on public.movements       to authenticated;
grant select                         on public.account_balances to authenticated;
grant select                         on public.goal_balances    to authenticated;
