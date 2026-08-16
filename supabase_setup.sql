create table if not exists public.night_shift_state (
  id integer primary key,
  owner_id uuid not null default auth.uid(),
  state jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.night_shift_state enable row level security;

drop policy if exists "night shift public read" on public.night_shift_state;
drop policy if exists "night shift owner read" on public.night_shift_state;
create policy "night shift owner read"
on public.night_shift_state
for select
to authenticated
using (owner_id = auth.uid());

drop policy if exists "night shift authenticated insert" on public.night_shift_state;
create policy "night shift authenticated insert"
on public.night_shift_state
for insert
to authenticated
with check (owner_id = auth.uid());

drop policy if exists "night shift authenticated update" on public.night_shift_state;
create policy "night shift authenticated update"
on public.night_shift_state
for update
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

do $$
begin
  alter publication supabase_realtime add table public.night_shift_state;
exception
  when duplicate_object then null;
end $$;
