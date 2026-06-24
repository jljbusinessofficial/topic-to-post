# Tasks — topic-to-post

## Sprint 1 — DB, seed data, demo results page
**Goal**: App renders real content for anonymous visitors; no login wall.

- [ ] Run migration SQL (post_sets, posts, users, audit_logs + open RLS)
- [ ] Seed 2 demo post_sets + 10 posts (5 each)
- [ ] Build `/posts/[id]` results page — reads posts from DB, renders 5 cards
- [ ] Copy-to-clipboard button per post card
- [ ] Empty state: "No posts found" message
- [ ] Loading skeleton while fetching
- [ ] Homepage `/` redirects to demo post_set or shows a preview CTA

**DoD**: Visiting `/posts/a1000000-…-001` shows 5 seeded posts. Copy button works.

---

## Sprint 2 — Core engine: form → AI → DB ✅ *v1 functional milestone*
**Goal**: A real user can generate 5 posts end-to-end.

- [ ] Build `/generate` page: topic input + goal dropdown (7 options)
- [ ] Server action: build prompt, call OpenAI, parse JSON response
- [ ] Write `post_set` + 5 `post` rows to Supabase
- [ ] Store `content_source`, `content_confidence`, `content_review_status` on each post
- [ ] Write `audit_log` row: `action='generate_completed'`
- [ ] Redirect to `/posts/[post_set_id]` on success
- [ ] Error state: OpenAI failure shows "Generation failed, try again"
- [ ] Fallback stub if OpenAI is unreachable

**DoD**: Submit form → 5 posts appear at `/posts/[id]`; rows exist in Supabase.

---

## Sprint 3 — Stripe Checkout: payment gates generation
**Goal**: Tool charges money before generating.

- [ ] Create Stripe product + monthly price ($19/mo)
- [ ] `/pricing` page: plan features + "Get Access" button
- [ ] `POST /api/checkout` — creates Stripe Checkout Session, returns URL
- [ ] `POST /api/webhooks/stripe` — on `checkout.session.completed`, set `payment_status='active'`
- [ ] Validate `stripe-signature` in webhook handler
- [ ] Gate `/generate`: if `payment_status != 'active'` → redirect to `/pricing`
- [ ] Write `audit_log` row: `action='payment_completed'`

**DoD**: Stripe test payment → `payment_status` flips → `/generate` is accessible.

---

## Sprint 4 — Auth + user dashboard
**Goal**: Users have accounts and can see past sessions.

- [ ] Enable Supabase Auth (email/password); sign-up + login pages
- [ ] Associate `post_set.user_id` with `auth.uid()` on generation
- [ ] `/dashboard`: list user's past `post_sets` (topic, date, link to results)
- [ ] Increment `tokens_used` after generation; show usage in dashboard
- [ ] Quota exceeded: block generation and show upgrade prompt

**DoD**: Logged-in user sees only their post_sets; token counter increments.

---

## Sprint 5 — Lock it down
**Goal**: Per-user data isolation; production-safe.

- [ ] Replace open RLS policies with `auth.uid() = user_id` owner policies
- [ ] Confirm no API route reads/writes rows without checking user_id
- [ ] Move all secrets to Vercel env; audit for any client-side exposure
- [ ] Remove or gate demo seed rows
- [ ] Final audit_log coverage check

**DoD**: User A cannot read User B's posts. All secrets server-side only.

---

## Gantt (sprint → feature)
```
Sprint 1 │ DB schema · Seed data · Results page · Copy button
Sprint 2 │ Generate form · OpenAI call · Posts written to DB  ← v1 functional
Sprint 3 │ Stripe Checkout · Payment webhook · Generate gate
Sprint 4 │ Auth · Dashboard · Token usage
Sprint 5 │ RLS lock-down · Security audit
```
