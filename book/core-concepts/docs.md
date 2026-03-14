# docs/ — Living Documentation

The `docs/` folder is your project's institutional knowledge base. It serves three audiences at once: human developers who need reference material, AI agents who need context before starting work, and doc-site generators that can publish it as a website.

## Why Living Documentation

Most project docs get written once and never updated. Six months later, the README describes a deployment process you replaced, references a config field you deleted, and links to a file that moved.

vibestack treats docs as living files. The `/docs` skill actively maintains them — capturing new learnings, removing stale references, and verifying that what's written still matches the code. Docs stay accurate because they get updated as part of the regular workflow, not as an afterthought.

## Structure

```
docs/
  README.md              # Explains the docs convention itself
  SUMMARY.md             # Table of contents (used by doc site generators)
  index.md               # Landing page — project overview and quick links

  # Organize by topic as the project grows
  architecture/          # System design, component docs, data flow
  integrations/          # External API quirks, SDK gotchas, auth flows
  operations/            # Deployment, monitoring, runbooks
  incidents/             # Postmortems and incident reports
```

Start flat. Create subdirectories only when you have enough related docs to justify grouping them.

## SUMMARY.md

`SUMMARY.md` is the table of contents. Doc site generators like GitBook, mdBook, and Docusaurus use it to build sidebar navigation.

```markdown
# Summary

[Home](index.md)

---

# Architecture

- [System Overview](architecture/overview.md)
- [Data Flow](architecture/data-flow.md)

# Operations

- [Deployment Guide](operations/deployment.md)
- [Runbook](operations/runbook.md)
```

Keep it updated whenever you add or remove a doc. If a doc isn't in SUMMARY.md, it's effectively invisible to anyone browsing the published docs.

## When to Write a Doc

Write a doc when:

- **You discover non-obvious behavior.** An API that silently drops fields over 1MB. A library that caches DNS lookups for 5 minutes. A config option that means something different than its name suggests. The stuff that wastes hours.
- **You make an architectural decision.** Why you chose Postgres over DynamoDB. Why the auth service is separate from the main API. Why you went with server-side rendering. Record the reasoning so future developers don't reverse it by accident.
- **An incident happens.** What broke, why, how it was fixed, and what to watch for going forward. Incident docs prevent repeat failures.
- **A subsystem is complex.** If understanding a part of the codebase takes more than reading the code, it needs a walkthrough.

Don't write a doc when:

- **The code is self-explanatory.** A well-named function with clear types doesn't need a doc.
- **It belongs in CLAUDE.md.** Quick-reference info (tech stack, build commands, conventions) goes in CLAUDE.md, not docs.
- **It's temporary.** In-progress notes and task context belong in TODO.md or conversation, not permanent docs.

## How to Write a Doc

### One topic per file

Don't combine unrelated things. "Database setup" and "authentication flow" are separate docs even if they're both part of the backend.

### Lead with context

Start with what this is and why it matters. Then get into the details.

```markdown
# Payment Processing

The payment service handles all Stripe interactions — creating charges,
managing subscriptions, and processing refunds. It's the most critical
service in the system because bugs here directly lose revenue.

## How it works
...
```

### Include concrete examples

Code snippets, config samples, API responses, error messages. The more concrete, the more useful.

### Record what surprised you

The stuff that's not in the official docs is the most valuable. "Stripe webhooks retry for up to 3 days but the retry interval isn't fixed — it uses exponential backoff starting at ~1 minute." That saves someone hours of debugging.

### Link to source

Reference specific files and line numbers when relevant. This helps readers (including Claude) find the actual code.

## The Feynman Clarity Pass

When the `/docs` skill writes or updates a doc, it applies a clarity pass inspired by Richard Feynman's teaching approach:

- **Lead with plain language.** The first sentence of each section should make sense to someone who isn't an expert.
- **Introduce jargon on first use.** The first time a technical term appears, briefly explain it.
- **Layer complexity.** Start simple, then go deeper. Wide shot first, then close-up.
- **Use analogy where it helps.** Compare non-obvious concepts to everyday things — but don't force it.
- **Short sentences, short paragraphs.** If a sentence has more than one comma, consider splitting it.
- **Active voice.** "The service processes the payment" not "The payment is processed by the service."

The goal is docs that are accurate for experts and accessible to newcomers — including AI agents encountering the codebase for the first time.

## For AI Agents

The `docs/README.md` file includes specific instructions for AI agents:

- **Read before you write.** Check `docs/` for existing context on the area you're working in before starting a task.
- **Write as you go.** When you discover something non-obvious during a task, add it to the relevant doc or create a new one.
- **Update SUMMARY.md** whenever you add or remove a doc.
- **Don't duplicate CLAUDE.md.** CLAUDE.md is the quick reference. Docs are for deep dives.

## Tips

- **Keep SUMMARY.md current.** It's the table of contents. If it's wrong, people can't find things.
- **Preserve incident reports.** They describe what happened at a point in time. Don't update them to match current state — they're historical records.
- **Don't over-document.** If the code is clear, a doc adds no value. Focus on decisions, architecture, non-obvious behavior, and operational knowledge.
- **Run `/docs` regularly.** It catches stale references and broken links automatically.
