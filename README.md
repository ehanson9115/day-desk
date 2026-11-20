# Day Desk

A designer's workday hub, built for Hacker Day (Nov 2026). One screen for today: schedule, to-dos, inbox, recent meeting notes, a scratchpad, and a "Plan my day" button that asks Claude to plan your open time.

Inspired by woday.app. Built with the HT Design System (Twenty Labs violet, Geist).

## What's here

| Path | What it is |
|------|------------|
| `index.html` | The **live** hub. Reads your own Google Calendar, Linear, Gmail and Granola through claude.ai connectors. |
| `demo/index.html` | The **frozen demo**. Same layout, made-up data, no live access. Safe to share. |
| `ht/` | HT Design System tokens, styles and Geist fonts. |

## How it runs

The live hub only works as a **claude.ai artifact**. It uses the artifact runtime (`claude.use("mcp" | "db" | "user" | "sample")`), so each viewer sees their own data through their own connectors. Opening `index.html` straight from GitHub or a local server shows the layout with every source marked "not available".

- Live hub (private): https://claude.ai/artifact/8s7WLp4ytDgzPXwSAwvqHq
- Demo (shared with the org): https://claude.ai/artifact/2JEGDgYotwTA7jerzogwam

To update the live hub, publish `index.html` with Claude Code's Artifact tool and include the `ht/` files plus these capabilities:

```json
{
  "mcp": { "servers": [
    { "server": "Google Calendar", "tools": ["list_events"] },
    { "server": "Linear", "tools": ["list_issues"] },
    { "server": "Gmail", "tools": ["search_threads"] },
    { "server": "Granola", "tools": ["search_meetings"] },
    { "server": "Slack", "tools": ["slack_search_public_and_private", "slack_read_user_profile"] }
  ]},
  "db": {}, "sample": {}, "user": {}
}
```

The demo publishes with `capabilities: {}` (no access to anything).

## Privacy

- No data is stored in this repo. The live page reads data at view time, in the viewer's browser.
- Your tasks and scratchpad are saved in the artifact's private per-user storage (`data/users/<id>/`), which nobody else can read.
- Keep the demo on synthetic data only. Never put real resident, client or agency data in it.
