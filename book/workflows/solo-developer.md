# Solo Developer

You're building something on your own — a side project, a startup MVP, a freelance contract. You don't have a team to delegate to, but you have Claude. Here's how to get the most out of vibestack as a solo developer.

## Your Advantage

Solo developers have one thing teams don't: zero coordination overhead. You don't need to worry about agent collisions, shared conventions, or domain ownership. The `[~]` pending markers in TODO.md still help if you run multiple Claude sessions, but most of the time you're running one session at a time.

This means you can move fast. Install vibestack, configure it, and start shipping.

## The Solo Workflow

### Morning: Plan

Open [TODO.md](../core-concepts/todo-md.md) and review the task list. Is the priority order still right? Did something change overnight — a user report, a new idea, a dependency update?

Reorder tasks if needed. Add new ones at the right priority level. Then kick off a session:

```bash
claw
/todo 3
```

Three tasks is a good daily target. Enough to make real progress, not so many that you lose track of what changed.

### Midday: Review

When Claude finishes, review the changes:

```bash
git diff
./ops.sh test
```

Read through the code. Does it match how you'd write it? Are there edge cases Claude missed? Make adjustments manually if needed.

This review step is important even when you trust Claude's work. You're building a product, and you need to understand every line that ships.

### End of Day: Capture

```
/docs
```

Let Claude capture what it learned. Then commit everything:

```bash
git add -A
git commit -m "feat: add input validation and rate limiting"
```

Push when you're ready.

## Using TODO as a Roadmap

For solo developers, TODO.md is more than a task tracker. It's your roadmap.

Run [`/todo populate`](../skills/todo.md) and look at what Claude identifies as the most important work. This gives you a staff-engineer-level audit of your codebase — security gaps, missing tests, reliability issues, performance problems. For free.

You don't have to follow the order exactly. If you know users are hitting a specific bug, bump that task up. But the default ordering (security -> reliability -> testing -> CI/CD) is a solid path to production-readiness.

### Mixing AI Tasks with Manual Tasks

Not everything should be done by Claude. Some tasks need your judgment:

```markdown
- [ ] Add rate limiting to `/api/` routes — Claude can handle this
- [ ] Design the pricing page — you need to do this
- [ ] Choose between Stripe and Paddle for payments — you need to decide, Claude can research
- [ ] Implement Stripe integration — Claude can handle this after you decide
```

Add manual tasks to TODO.md alongside AI tasks. Skip them during `/todo` runs (Claude will see they require human input and move on). This keeps your full roadmap in one place.

## Keeping Docs for Future-You

When you're solo, docs feel pointless. You know how everything works. Why write it down?

Because in three months, you won't remember. And when you open Claude Code after a break, it won't know either — unless the docs are there.

The most valuable solo-developer docs:

- **Why you chose X over Y.** You'll question your own decisions later. Record the reasoning now.
- **Integration quirks.** That weird thing the Stripe API does with webhook signatures. That environment variable Vercel requires for server-side rendering. Write it down.
- **How to deploy.** Even if it's just "push to main," document the full process including any manual steps.

Run `/docs` after every significant work session. It takes a minute and saves hours later.

## Running Multiple Sessions

If you want to parallelize, you can run multiple Claude sessions on different tasks:

```bash
# Terminal 1
claw
/todo 1  # picks up task 1

# Terminal 2
claw
/todo 1  # picks up task 2 (task 1 is marked [~])
```

The pending markers prevent collisions. But as a solo developer, you'll usually get more value from one focused session than two parallel ones — you can only review so many changes at once.

## Tips for Solo Developers

- **Commit often.** Small, focused commits are easier to review and revert than large batches.
- **Trust but verify.** Claude's code is usually good, but you're the one who ships it. Read the diffs.
- **Don't skip tests.** It's tempting when you're moving fast. But tests are what let Claude work confidently — if it can run `./ops.sh test` and verify its changes, it makes fewer mistakes.
- **Use [`/bosskey`](../skills/bosskey.md) for accountability.** Even without a team, generating a standup summary helps you track your own progress and stay focused.
- **Repopulate regularly.** When you've cleared 80% of the list, run `/todo populate`. Fresh eyes on the codebase often catch things the previous pass missed.
