# Agentic Layer — topic-to-post

## Risk Classification

### Low — Auto (no approval needed)
- Generate 5 draft posts from topic + goal
- Increment `tokens_used` after generation
- Write `audit_log` rows for generate events

### Medium — Light approval (user confirms)
- Regenerate a single post (replaces existing content in DB)
- Archive a `post_set`

### High — Always approval
- Initiate Stripe Checkout session (user explicitly clicks "Pay")
- Cancel subscription via Stripe API

### Critical — Human only
- Issue refund via Stripe
- Permanently delete user account + all data
- Modify `monthly_quota` on a user record

## Named Tools (v1)
| Tool | Risk | Description |
|---|---|---|
| `generate_posts` | Low | Calls OpenAI, writes post_set + posts |
| `create_checkout_session` | High | Creates Stripe Checkout session |
| `record_payment` | High | Webhook handler: sets payment_status |
| `write_audit_log` | Low | Appends immutable log row |

## Audit Log Fields
`action`, `user_id`, `object_type`, `object_id`, `meta` (tokens, Stripe event ID, IP), `created_at`

## v1 vs Later
- v1: `generate_posts` + `create_checkout_session` + `record_payment`
- Later: `regenerate_single_post`, `cancel_subscription`, `export_posts_csv`
