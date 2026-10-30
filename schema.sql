-- Rode este script no SQL Editor do Supabase para criar o álbum privado.
-- Configure Authentication > URL Configuration: adicione a URL do GitHub Pages em Site URL e Redirect URLs.
-- Crie também um bucket PRIVADO chamado family-photos em Storage.
create extension if not exists pgcrypto;
create table if not exists public.photos (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 storage_path text not null unique,
 file_name text not null,
 title text,
 category text not null default 'Momentos',
 created_at timestamptz not null default now()
);
alter table public.photos enable row level security;
create policy "Fotos visíveis ao dono" on public.photos for select to authenticated using (auth.uid() = user_id);
create policy "Usuário cadastra suas fotos" on public.photos for insert to authenticated with check (auth.uid() = user_id);
create policy "Usuário atualiza suas fotos" on public.photos for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Usuário remove suas fotos" on public.photos for delete to authenticated using (auth.uid() = user_id);
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types) values ('family-photos','family-photos',false,15728640,array['image/jpeg','image/png','image/webp','image/heic','image/heif']) on conflict (id) do update set public=false;
create policy "Ler fotos próprias" on storage.objects for select to authenticated using (bucket_id='family-photos' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Enviar fotos próprias" on storage.objects for insert to authenticated with check (bucket_id='family-photos' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Alterar fotos próprias" on storage.objects for update to authenticated using (bucket_id='family-photos' and (storage.foldername(name))[1]=auth.uid()::text) with check (bucket_id='family-photos' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Excluir fotos próprias" on storage.objects for delete to authenticated using (bucket_id='family-photos' and (storage.foldername(name))[1]=auth.uid()::text);
