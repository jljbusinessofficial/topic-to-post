# Test Plan — topic-to-post

## Success Scenario (manual, end-to-end)
1. Visit `/` — homepage loads; demo post preview visible without login
2. Visit `/posts/a1000000-0000-0000-0000-000000000001` — 5 seeded posts render
3. Click "Copy" on post 1 — text lands in clipboard; button shows "Copied!"
4. Visit `/generate` — form shows topic input + goal dropdown with 7 options
5. Enter topic `"home fitness"`, select goal `"grow Instagram followers"`, submit
6. See loading state (spinner or skeleton)
7. Redirected to `/posts/[new-id]` — 5 new posts render with correct topic context
8. Open Supabase dashboard — confirm 1 `post_set` row + 5 `post` rows created
9. Confirm `audit_log` row: `action='generate_completed'`
10. Visit `/pricing` — plan details visible; "Get Access" button present
11. Click "Get Access" → redirected to Stripe Checkout (test mode)
12. Complete payment with Stripe test card `4242 4242 4242 4242`
13. Confirm `user.payment_status` = `'active'` in DB
14. Confirm `audit_log` row: `action='payment_completed'`

## Empty / Error Cases
| Case | Expected behaviour |
|---|---|
| Visit `/posts/nonexistent-id` | "Post set not found" message, link back to `/generate` |
| Submit `/generate` with blank topic | Form validation error: "Topic is required" |
| OpenAI API returns error | "Generation failed. Please try again." — no partial rows written |
| Stripe webhook arrives with wrong signature | 400 response; no DB write |
| User hits monthly quota | Generation blocked; "You've used your monthly quota" message + upgrade link |
| User visits `/generate` without active payment | Redirect to `/pricing` |

## Regression Checks (after each sprint)
- Seed demo rows still render after RLS policy changes
- Copy button does not regress after auth wiring
- Token counter increments exactly once per generation
