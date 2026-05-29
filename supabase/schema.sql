create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  company_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.ingresos (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  cliente text not null,
  monto numeric(12,2) not null check (monto > 0),
  fecha date not null,
  periodo text not null,
  concepto text,
  notas text,
  created_at timestamptz not null default now()
);

create index if not exists ingresos_user_id_idx on public.ingresos(user_id);
create index if not exists ingresos_periodo_idx on public.ingresos(periodo);

create table if not exists public.gastos (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  categoria text not null,
  monto numeric(12,2) not null check (monto > 0),
  fecha date not null,
  periodo text not null,
  descripcion text not null,
  otros_detalle text,
  notas text,
  created_at timestamptz not null default now()
);

create index if not exists gastos_user_id_idx on public.gastos(user_id);
create index if not exists gastos_periodo_idx on public.gastos(periodo);

create table if not exists public.user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  app_name text default 'Finanzas Pro Codex',
  currency_code text default 'MXN',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''));

  insert into public.user_settings (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create table if not exists public.montos_fijos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  tipo text not null check (tipo in ('ingreso', 'gasto')),
  nombre text not null,
  monto numeric(12,2) not null default 0,
  categoria text,
  created_at timestamptz not null default now()
);

create index if not exists montos_fijos_user_id_idx on public.montos_fijos(user_id);
alter table public.montos_fijos enable row level security;
create policy "user_own_montos_fijos" on public.montos_fijos for all using (auth.uid() = user_id);
