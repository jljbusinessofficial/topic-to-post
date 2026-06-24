# Intelligence Layer — topic-to-post

## Messy Input
User types a free-text topic ("baking tips", "my yoga studio") and picks a goal from a dropdown.

## Auto-Structure Schema
The server builds this object before calling OpenAI:
```json
{
  "topic": "baking tips",
  "goal": "get email signups",
  "post_count": 5,
  "tone": "friendly, practical",
  "include_cta": true
}
```

## Prompt Design (v1)
- System: "You are a social media copywriter. Return a JSON array of exactly 5 short text posts."
- User: "Topic: {topic}. Goal: {goal}. Each post must include a clear CTA."
- Response parsed as `{ posts: [{ day: 1, content: "..." }, ...] }`

## AI Fields Stored Per Post
| Field | Value |
|---|---|
| `content` | generated text |
| `content_source` | `'openai/gpt-4o'` |
| `content_confidence` | token log-prob proxy or fixed `0.9` in v1 |
| `content_review_status` | `'unreviewed'` on creation |

## Events to Track
- `generate_requested` — topic + goal submitted
- `generate_completed` — posts written to DB
- `generate_failed` — OpenAI error or parse failure
- `post_copied` — user clicked copy on a post

## v1 vs Later
| v1 | Later |
|---|---|
| Fixed tone, single platform | Platform-specific tone presets |
| Confidence = fixed `0.9` | Real log-prob scoring |
| No ranking | Score posts by predicted engagement |
| Manual review_status | Auto-approve high-confidence posts |
