# Architecture — topic-to-post

## Stack
- **Frontend**: Next.js 14 (App Router) on Vercel
- **Database + Auth**: Supabase (Postgres + RLS + Auth)
- **AI**: OpenAI API (`gpt-4o`, server-side only)
- **Payments**: Stripe Checkout + Webhooks

## Now vs Later
| Now (v1) | Later |
|---|---|
| Topic form → AI → 5 posts in DB | Post editing and regeneration |
| Stripe Checkout gate | Subscription management portal |
| Results page with copy buttons | Platform-specific tone presets |
| Demo seed data, no login wall | Per-user RLS lock-down |
| Token usage counter | Monthly quota enforcement UI |

## Key User Action — Step by Step
1. User submits `/generate` form (topic + goal)
2. Server action checks `user.payment_status` — redirects to `/pricing` if not active
3. Server calls OpenAI with a structured prompt; receives JSON array of 5 posts
4. Server writes one `post_set` row + five `post` rows to Supabase
5. Server increments `user.tokens_used` by response token count
6. User is redirected to `/posts/[post_set_id]` — reads posts from DB and renders them

## Layer Plan
1. **Data first** — schema, seed rows, RLS policies
2. **App logic** — form → server action → DB read/write (no AI yet)
3. **AI on top** — swap stub content for live OpenAI call
4. **Payments** — Stripe gate wraps the generate action

## Core Without AI
If OpenAI is unavailable, the server action falls back to a static stub response and still writes rows. The DB, form, and results page all work independently.
