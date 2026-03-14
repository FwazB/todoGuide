# Tips & Troubleshooting

Practical advice for getting the most out of vibestack, plus solutions to common problems.

## Common Pitfalls

### CLAUDE.md is too long

If CLAUDE.md grows past 100 lines, you're putting too much in it. It loads into every conversation, so bloat wastes context.

**Fix:** Move detailed explanations to `docs/` and link to them from CLAUDE.md. Keep CLAUDE.md as a quick reference — bullet points and short descriptions, not paragraphs.

### TODO.md tasks are too vague

"Improve the API" isn't a task. Claude won't know where to start, and the result will be unfocused.

**Fix:** Be specific. Reference actual files, endpoints, or functions. "Add request validation to `POST /api/orders` in `src/handlers/orders.ts` — validate required fields and return 400 with field-level errors."

### ops.sh commands are out of date

You changed your build system but forgot to update ops.sh. Now Claude runs the wrong commands.

**Fix:** Treat ops.sh like code — update it when your tooling changes. Run `/docs` periodically to catch stale references in both ops.sh and CLAUDE.md.

### Docs are stale

Six-month-old docs that describe deleted features are worse than no docs. They actively mislead Claude.

**Fix:** Run `/docs` after significant changes. It scans for stale references and verifies them against the codebase before removing them.

### Too many squad domains

Eight thin domains with generic advice waste context. Claude loads rule files for every domain it touches, so each one should earn its place.

**Fix:** Aim for 3-5 domains. Merge related areas. Only create a domain when it has conventions that genuinely differ from the project defaults.

## Performance Tips

### Large Codebases

For projects with thousands of files:

- **Use squad mode.** Domain-specific rules keep context focused instead of loading everything.
- **Scope tasks tightly.** "Fix all error handling" is too broad. "Add error handling to the payment flow in `src/services/payment.ts`" gives Claude a clear target.
- **Use `.gitignore`-style exclusions.** Claude Code respects gitignore patterns. Make sure `node_modules/`, `dist/`, and other generated directories are excluded.

### Long Sessions

If a session goes on for many tasks:

- **Commit between tasks.** This gives you clean rollback points if something goes wrong.
- **Run `/todo 3-5` instead of `/todo`.** Shorter sessions are easier to review and less likely to accumulate errors.
- **Check test output.** If tests start failing partway through a session, stop and investigate before continuing.

### Parallel Sessions

Running multiple Claude sessions:

- **Assign different domains.** If developer A works on auth and developer B works on the API, they won't conflict.
- **Watch for shared files.** Two agents editing the same file will cause merge conflicts. TODO.md handles this with `[~]` markers, but source files don't have that protection.
- **Keep sessions focused.** Two focused sessions outperform two sessions that each touch everything.

## FAQ

### Can I use vibestack with other AI tools?

The convention files (CLAUDE.md, TODO.md, ops.sh, docs/) are useful with any AI tool. They're plain Markdown and Bash. The skills (`.claude/skills/`) are specific to Claude Code.

### Do I need to run `/vibestack` every time?

No. Run it once during setup. Run it again if the project structure changes significantly (new services, major refactoring, changed tech stack). For day-to-day work, just use `/todo` and `/docs`.

### Can I delete skills I don't use?

Yes. Skills are independent. If you don't use `/bosskey`, delete the `.claude/skills/bosskey/` directory. It won't affect anything else.

### What if Claude fills in CLAUDE.md wrong?

Edit it. CLAUDE.md is a regular file. Fix whatever's wrong and it'll be correct for every future session. The `/vibestack` output is a starting point, not a final answer.

### How do I handle secrets?

Never put secrets in CLAUDE.md, settings.json, or any committed file. Use `.env` files (gitignored) for local secrets. Reference them in CLAUDE.md by variable name: "Stripe key in `.env.local` as `STRIPE_SECRET_KEY`."

### What if `/todo populate` generates bad tasks?

Edit TODO.md. Remove tasks that don't make sense, add ones that do, reorder priorities. It's your roadmap — Claude seeds it, but you own it.

### Can I use vibestack in a monorepo?

Yes, but you'll want squad mode. Each package or service becomes a domain with its own rules. The root CLAUDE.md covers project-wide conventions, and domain rules cover package-specific ones.

## Debugging

### Claude ignores CLAUDE.md conventions

Check that CLAUDE.md is in the project root (not a subdirectory). Claude Code loads it from the working directory automatically.

### Skills don't appear in the `/` menu

Check the file path: `.claude/skills/<name>/SKILL.md`. The directory name becomes the command name. Make sure:
- The file is named exactly `SKILL.md` (case-sensitive)
- The frontmatter has `user-invocable: true` (or doesn't have `user-invocable: false`)
- The YAML frontmatter is valid

### Hooks don't fire

1. Check that the hook script is executable: `chmod +x .claude/hooks/notify-done.sh`
2. Test the script directly: `bash .claude/hooks/notify-done.sh`
3. Check the matcher in settings.json — an empty matcher `""` matches everything

### `/todo` skips tasks

Claude skips tasks marked `[~]` (pending) because it assumes another agent is working on them. If a task is stuck as pending from a crashed session, change it back to `[ ]` manually.

### Squad rules don't load

Check the `paths:` frontmatter in the rule file. The glob patterns must match the files you're working on. Test with:

```bash
# See what files a pattern matches
ls src/auth/**/*
```

If the pattern is too narrow, broaden it. If files moved, update the pattern.
