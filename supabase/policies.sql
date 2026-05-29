alter table public.profiles enable row level security;
alter table public.ingresos enable row level security;
alter table public.gastos enable row level security;
alter table public.user_settings enable row level security;
alter table public.montos_fijos enable row level security;

-- profiles
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- ingresos
drop policy if exists "ingresos_select_own" on public.ingresos;
create policy "ingresos_select_own" on public.ingresos
  for select using (auth.uid() = user_id);

drop policy if exists "ingresos_insert_own" on public.ingresos;
create policy "ingresos_insert_own" on public.ingresos
  for insert with check (auth.uid() = user_id);

drop policy if exists "ingresos_update_own" on public.ingresos;
create policy "ingresos_update_own" on public.ingresos
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "ingresos_delete_own" on public.ingresos;
create policy "ingresos_delete_own" on public.ingresos
  for delete using (auth.uid() = user_id);

-- gastos
drop policy if exists "gastos_select_own" on public.gastos;
create policy "gastos_select_own" on public.gastos
  for select using (auth.uid() = user_id);

drop policy if exists "gastos_insert_own" on public.gastos;
create policy "gastos_insert_own" on public.gastos
  for insert with check (auth.uid() = user_id);

drop policy if exists "gastos_update_own" on public.gastos;
create policy "gastos_update_own" on public.gastos
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "gastos_delete_own" on public.gastos;
create policy "gastos_delete_own" on public.gastos
  for delete using (auth.uid() = user_id);

-- user_settings
drop policy if exists "settings_select_own" on public.user_settings;
create policy "settings_select_own" on public.user_settings
  for select using (auth.uid() = user_id);

drop policy if exists "settings_insert_own" on public.user_settings;
create policy "settings_insert_own" on public.user_settings
  for insert with check (auth.uid() = user_id);

drop policy if exists "settings_update_own" on public.user_settings;
create policy "settings_update_own" on public.user_settings
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- montos_fijos
drop policy if exists "montos_fijos_select_own" on public.montos_fijos;
create policy "montos_fijos_select_own" on public.montos_fijos
  for select using (auth.uid() = user_id);

drop policy if exists "montos_fijos_insert_own" on public.montos_fijos;
create policy "montos_fijos_insert_own" on public.montos_fijos
  for insert with check (auth.uid() = user_id);

drop policy if exists "montos_fijos_update_own" on public.montos_fijos;
create policy "montos_fijos_update_own" on public.montos_fijos
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "montos_fijos_delete_own" on public.montos_fijos;
create policy "montos_fijos_delete_own" on public.montos_fijos
  for delete using (auth.uid() = user_id);
