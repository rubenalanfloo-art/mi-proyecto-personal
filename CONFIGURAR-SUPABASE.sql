-- Ejecuta todo este archivo una sola vez en Supabase > SQL Editor
create table if not exists public.personal_backups (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.personal_backups enable row level security;
drop policy if exists "Usuarios leen su respaldo" on public.personal_backups;
create policy "Usuarios leen su respaldo" on public.personal_backups for select using (auth.uid() = user_id);
drop policy if exists "Usuarios crean su respaldo" on public.personal_backups;
create policy "Usuarios crean su respaldo" on public.personal_backups for insert with check (auth.uid() = user_id);
drop policy if exists "Usuarios actualizan su respaldo" on public.personal_backups;
create policy "Usuarios actualizan su respaldo" on public.personal_backups for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

insert into storage.buckets (id,name,public)
values ('personal-media','personal-media',false)
on conflict (id) do nothing;
drop policy if exists "Usuarios suben sus fotos" on storage.objects;
create policy "Usuarios suben sus fotos" on storage.objects for insert to authenticated with check (bucket_id='personal-media' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "Usuarios actualizan sus fotos" on storage.objects;
create policy "Usuarios actualizan sus fotos" on storage.objects for update to authenticated using (bucket_id='personal-media' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "Usuarios leen sus fotos" on storage.objects;
create policy "Usuarios leen sus fotos" on storage.objects for select to authenticated using (bucket_id='personal-media' and (storage.foldername(name))[1]=auth.uid()::text);
