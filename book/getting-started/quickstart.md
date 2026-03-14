# Quickstart

The entire vibestack setup in under 2 minutes.

## 1. Install

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/vibestackmd/vibestack/main/install.sh | bash
```

The installer creates `CLAUDE.md`, `TODO.md`, `ops.sh`, `docs/`, and `.claude/skills/` in your project. It may also offer to install dev tools — say yes or no to each.

**Verify:** Run `ls CLAUDE.md TODO.md ops.sh` and confirm all three files exist.

## 2. Configure

Launch Claude Code and run the setup skill:

```bash
claw
```

```
/vibestack
```

Claude reads your project — build files, directory structure, dependencies, existing docs — and fills in the templates with real content. This takes 1-2 minutes.

**Verify:** Open `CLAUDE.md` and check that the Project Overview and Tech Stack sections describe your actual project, not placeholder text.

## 3. Work

Generate a task list and start executing:

```
/todo populate
```

Claude scans the codebase and writes 10-20 prioritized tasks into `TODO.md`. Then:

```
/todo
```

Claude works through the tasks top to bottom — reading code, making changes, running tests, marking each one done.

**Tip:** Run `/todo 3` to limit to 3 tasks per session, so you can review between batches.

## 4. Capture

After a work session, save what was learned:

```
/docs
```

Claude reviews the conversation for decisions, discoveries, and architectural changes, then writes them to `docs/`. It also cleans up any stale references.

## 5. Repeat

From here, your daily workflow is:

```
/todo          # work through tasks
/todo populate # generate fresh tasks when the list is empty
/docs          # capture learnings after each session
```

Each cycle makes the next one smarter — docs accumulate, conventions get refined, and Claude starts every session with better context.

## Troubleshooting

**`claw` command not found:** The installer may not have added the alias. Run `echo 'alias claw="claude"' >> ~/.zshrc && source ~/.zshrc` or just use `claude` directly.

**`/vibestack` shows placeholder output:** Make sure you're in the project directory when you run `claw`. Claude Code loads CLAUDE.md from the working directory.

**Tasks seem wrong:** Edit `TODO.md` directly. Remove irrelevant tasks, add your own, reorder priorities. It's your roadmap.

For the full explanation of each step, start with [What is vibestack?](what-is-vibestack.md).
