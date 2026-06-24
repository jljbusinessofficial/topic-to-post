# Security — topic-to-post

## Secret Handling
- `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` live in Vercel environment variables only
- Never imported in any client component or exposed via a public API route
- All AI and payment calls run in Next.js Server Actions or Route Handlers

## Permission Model
- **v1 (demo)**: open RLS policies — all rows readable/writable by anyone
- **Lock-down sprint**: `auth.uid() = user_id` owner policies on `post_sets`, `posts`, `users`
- `audit_logs` is append-only; no delete policy ever granted to app roles
- Stripe webhook endpoint validates `stripe-signature` header before processing

## Approved Tools Rule
- Server actions may only call: `generate_posts`, `create_checkout_session`, `record_payment`, `write_audit_log`
- No `eval`, no `run_any`, no dynamic SQL construction from user input
- User input (topic, goal) is passed as prompt context only — never interpolated into SQL

## Audit Principle
Every meaningful state change (generate, payment, quota exceeded, login) writes an `audit_log` row synchronously. Logs are never updated or deleted.
