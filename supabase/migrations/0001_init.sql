create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  email text,
  payment_status text not null default 'free',
  stripe_customer_id text,
  stripe_subscription_id text,
  tokens_used integer not null default 0,
  monthly_quota integer not null default 50000
);

alter table users enable row level security;
drop policy if exists "users_v1_read" on users;
create policy "users_v1_read" on users for select using (true);
drop policy if exists "users_v1_write" on users;
create policy "users_v1_write" on users for all using (true) with check (true);

create table if not exists post_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  topic text not null,
  goal text not null,
  status text not null default 'generated'
);

alter table post_sets enable row level security;
drop policy if exists "post_sets_v1_read" on post_sets;
create policy "post_sets_v1_read" on post_sets for select using (true);
drop policy if exists "post_sets_v1_write" on post_sets;
create policy "post_sets_v1_write" on post_sets for all using (true) with check (true);

create table if not exists posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  post_set_id uuid references post_sets(id) on delete cascade,
  day_number integer not null,
  content text not null,
  content_source text not null default 'openai/gpt-4o',
  content_confidence numeric,
  content_review_status text not null default 'unreviewed',
  platform_hint text
);

alter table posts enable row level security;
drop policy if exists "posts_v1_read" on posts;
create policy "posts_v1_read" on posts for select using (true);
drop policy if exists "posts_v1_write" on posts;
create policy "posts_v1_write" on posts for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  action text not null,
  object_type text,
  object_id uuid,
  meta jsonb
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into post_sets (id, topic, goal, status) values
  ('a1000000-0000-0000-0000-000000000001', 'baking tips', 'get email signups', 'generated'),
  ('a1000000-0000-0000-0000-000000000002', 'home office productivity', 'drive website traffic', 'generated');

insert into posts (post_set_id, day_number, content, content_source, content_confidence, content_review_status, platform_hint) values
  ('a1000000-0000-0000-0000-000000000001', 1, 'Want to bake better bread at home? Start with one simple trick: weigh your flour instead of scooping it. Consistent weight = consistent loaves every time. 🍞 Join our free baking newsletter for a new tip every week → [link]', 'openai/gpt-4o', 0.92, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000001', 2, 'The secret to fluffy muffins? Don''t overmix! Stir just until the dry ingredients disappear. Lumps are your friend. Want 5 more baking secrets? Grab our free guide → [link]', 'openai/gpt-4o', 0.88, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000001', 3, 'Room-temperature butter isn''t just a suggestion — it''s the difference between a flat cookie and a perfect one. Sign up for our baking list and never miss a tip → [link]', 'openai/gpt-4o', 0.90, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000001', 4, 'Bread not rising? Your yeast might be dead. Test it: dissolve in warm water with a pinch of sugar — it should foam in 10 min. No foam = toss it. More troubleshooting tips in our newsletter → [link]', 'openai/gpt-4o', 0.91, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000001', 5, 'Friday bake day tip: preheat your baking sheet before adding cookies. Hot pan = instant bottom heat = chewier centers. Get a weekly baking tip straight to your inbox → [link]', 'openai/gpt-4o', 0.87, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000002', 1, 'Your desk setup is quietly wrecking your focus. Fix #1: put your phone in a drawer — not face-down, in a drawer. Read how I redesigned my home office for deep work → [link]', 'openai/gpt-4o', 0.93, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000002', 2, 'The Pomodoro method works — but only if you protect the break. Step away from the screen. 5 real minutes beats 25 minutes of half-focus. See the full productivity system on our site → [link]', 'openai/gpt-4o', 0.89, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000002', 3, 'Noise-cancelling headphones are nice. A "do not disturb" sign on your door is free. Start with the sign. More low-cost home office wins at → [link]', 'openai/gpt-4o', 0.85, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000002', 4, 'End every work day by writing tomorrow''s top 3 tasks. Takes 2 minutes. Saves 30 minutes of morning confusion. Full morning routine breakdown on the blog → [link]', 'openai/gpt-4o', 0.94, 'unreviewed', 'general'),
  ('a1000000-0000-0000-0000-000000000002', 5, 'Working from home tip: natural light isn''t a luxury, it''s a performance tool. Position your monitor perpendicular to the window. See the full desk layout guide → [link]', 'openai/gpt-4o', 0.90, 'unreviewed', 'general');