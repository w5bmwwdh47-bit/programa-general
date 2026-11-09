-- ============================================================
-- EXTINPLAGAS · Operaciones compartidas
-- Ejecuta TODO este script en Supabase > SQL Editor > Run.
-- Es seguro ejecutarlo más de una vez.
-- Usa tablas con prefijo ops_ para no mezclarse con la aplicación
-- de Gestión financiera (company_members, app_data).
-- ============================================================

create table if not exists public.ops_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','tecnico')),
  created_at timestamptz not null default now()
);

create table if not exists public.ops_records (
  collection text not null,
  id text not null,
  data jsonb not null,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);

alter table public.ops_members enable row level security;
alter table public.ops_records enable row level security;

-- Rol del usuario que consulta (security definer evita recursión en las políticas).
create or replace function public.ops_role() returns text
language sql stable security definer set search_path = public as $$
  select role from public.ops_members where user_id = auth.uid()
$$;

-- Cada usuario solo puede ver su propio rol.
drop policy if exists "ops_members: ver mi rol" on public.ops_members;
create policy "ops_members: ver mi rol" on public.ops_members
  for select to authenticated using (user_id = auth.uid());

-- ADMINISTRADOR: lee, crea, modifica y borra todo.
drop policy if exists "ops_records: admin lee" on public.ops_records;
create policy "ops_records: admin lee" on public.ops_records
  for select to authenticated using (public.ops_role() = 'admin');
drop policy if exists "ops_records: admin inserta" on public.ops_records;
create policy "ops_records: admin inserta" on public.ops_records
  for insert to authenticated with check (public.ops_role() = 'admin');
drop policy if exists "ops_records: admin actualiza" on public.ops_records;
create policy "ops_records: admin actualiza" on public.ops_records
  for update to authenticated using (public.ops_role() = 'admin') with check (public.ops_role() = 'admin');
drop policy if exists "ops_records: admin borra" on public.ops_records;
create policy "ops_records: admin borra" on public.ops_records
  for delete to authenticated using (public.ops_role() = 'admin');

-- TÉCNICO: solo lee órdenes, clientes, técnicos y la configuración de encabezados;
-- solo puede crear/actualizar órdenes (sus informes). No ve finanzas, cotizaciones ni cartera.
drop policy if exists "ops_records: tecnico lee" on public.ops_records;
create policy "ops_records: tecnico lee" on public.ops_records
  for select to authenticated using (
    public.ops_role() = 'tecnico'
    and (collection in ('orders','clients','techs') or (collection = 'cfg' and id = 'prices'))
  );
drop policy if exists "ops_records: tecnico inserta ordenes" on public.ops_records;
create policy "ops_records: tecnico inserta ordenes" on public.ops_records
  for insert to authenticated with check (public.ops_role() = 'tecnico' and collection = 'orders');
drop policy if exists "ops_records: tecnico actualiza ordenes" on public.ops_records;
create policy "ops_records: tecnico actualiza ordenes" on public.ops_records
  for update to authenticated
  using (public.ops_role() = 'tecnico' and collection = 'orders')
  with check (public.ops_role() = 'tecnico' and collection = 'orders');

-- Tiempo real: los demás usuarios reciben los cambios al instante.
do $$ begin
  alter publication supabase_realtime add table public.ops_records;
exception when duplicate_object then null;
when others then
  if position('already member' in sqlerrm) = 0 then raise; end if;
end $$;

-- Fotos: carpeta privada (solo usuarios con rol).
insert into storage.buckets (id, name, public) values ('ops-fotos', 'ops-fotos', false)
on conflict (id) do nothing;

drop policy if exists "ops-fotos: leer" on storage.objects;
create policy "ops-fotos: leer" on storage.objects
  for select to authenticated using (bucket_id = 'ops-fotos' and public.ops_role() is not null);
drop policy if exists "ops-fotos: subir" on storage.objects;
create policy "ops-fotos: subir" on storage.objects
  for insert to authenticated with check (bucket_id = 'ops-fotos' and public.ops_role() is not null);
drop policy if exists "ops-fotos: actualizar" on storage.objects;
create policy "ops-fotos: actualizar" on storage.objects
  for update to authenticated using (bucket_id = 'ops-fotos' and public.ops_role() is not null)
  with check (bucket_id = 'ops-fotos' and public.ops_role() is not null);
drop policy if exists "ops-fotos: borrar" on storage.objects;
create policy "ops-fotos: borrar" on storage.objects
  for delete to authenticated using (bucket_id = 'ops-fotos' and public.ops_role() = 'admin');

-- ============================================================
-- PRIMER ADMINISTRADOR (el usuario ya debe existir en Authentication > Users)
-- ============================================================
insert into public.ops_members (user_id, role)
select id, 'admin' from auth.users where email = 'jeanc200129@gmail.com'
on conflict (user_id) do update set role = 'admin';

-- ============================================================
-- PARA CADA TÉCNICO: 1) créalo en Authentication > Users (correo + contraseña)
-- 2) ejecuta esto con su correo:
--   insert into public.ops_members (user_id, role)
--   select id, 'tecnico' from auth.users where email = 'correo.del.tecnico@gmail.com'
--   on conflict (user_id) do update set role = 'tecnico';
-- 3) en la aplicación, Técnicos > Nuevo técnico, con ese mismo correo.
-- ============================================================
