# PRD — topic-to-post

## Problem
Solopreneurs and small business owners know they should post consistently on social media but run out of time and ideas. Writing 5 posts from scratch every week is a recurring pain they'll pay to eliminate.

## Target User
- Solopreneurs and small business owners with an active social presence
- Freelance social media managers handling multiple clients

## Core Objects
| Object | What it is |
|---|---|
| `post_set` | One generation session: a topic + goal + 5 resulting posts |
| `post` | A single AI-generated, ready-to-use text post |
| `user` | Account holder with payment status and token quota |
| `audit_log` | Immutable record of every significant action |

## MVP Must-Haves
- [ ] `/generate` form: topic text input + goal dropdown (7 goals)
- [ ] Server-side OpenAI call → 5 posts written to Supabase
- [ ] `/posts/[id]` results page with copy-to-clipboard per post
- [ ] Stripe Checkout: payment required before generating
- [ ] Payment webhook sets `user.payment_status = 'active'`
- [ ] `/pricing` page with plan details and checkout CTA
- [ ] Token/credit usage incremented after each generation

## Non-Goals (v1)
- Auto-posting to any platform
- AI image or video generation
- Hashtag research or analytics
- Multi-platform content calendars
- Team/agency seats

## Success Criteria
A user visits the site → views demo posts → clicks "Get Access" → completes Stripe payment → fills in topic="baking tips" + goal="get email signups" → clicks Generate → sees 5 ready-to-post texts → copies one to clipboard. All data persists. No login required until the lock-down sprint.
