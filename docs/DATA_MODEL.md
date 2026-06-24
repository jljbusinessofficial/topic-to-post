# Data Model — topic-to-post

## `users`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | maps to auth.uid() at lock-down |
| email | text | |
| payment_status | text | `'free'` \| `'active'` \| `'cancelled'` |
| stripe_customer_id | text | |
| stripe_subscription_id | text | |
| tokens_used | integer | resets monthly |
| monthly_quota | integer | default 50 000 |
| created_at | timestamptz | |

## `post_sets`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| topic | text | user input |
| goal | text | selected from dropdown |
| status | text | `'generated'` \| `'archived'` |
| created_at | timestamptz | |

## `posts`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| post_set_id | uuid FK → post_sets | cascade delete |
| day_number | integer | 1–5 |
| content | text | **AI field** |
| content_source | text | e.g. `'openai/gpt-4o'` |
| content_confidence | numeric | 0–1 |
| content_review_status | text | `'unreviewed'` \| `'approved'` \| `'edited'` |
| platform_hint | text | e.g. `'general'`, `'linkedin'` |
| created_at | timestamptz | |

## `audit_logs`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| action | text | e.g. `'generate'`, `'payment_completed'` |
| object_type | text | |
| object_id | uuid | |
| meta | jsonb | tokens used, Stripe event ID, etc. |
| created_at | timestamptz | |

## RLS
- v1: permissive open policies on all tables (demo-first)
- Lock-down sprint: replace with `auth.uid() = user_id` owner policies
