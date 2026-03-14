# Quickstart

The entire vibestack setup in under 2 minutes.

## 1. Install

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/vibestackmd/vibestack/main/install.sh | bash
```

## 2. Configure

```bash
claw
```

```
/vibestack
```

Claude reads your project and fills in `CLAUDE.md`, `ops.sh`, `docs/`, and `TODO.md` with real content.

## 3. Work

```
/todo populate
/todo
```

Claude generates a prioritized task list and starts working through it.

## 4. Capture

```
/docs
```

Claude writes what it learned into your docs folder.

## 5. Repeat

```
/todo          # keep working through tasks
/todo populate # generate fresh tasks when the list is empty
/docs          # capture learnings after each session
```

That's it. For the full explanation, start with [What is vibestack?](what-is-vibestack.md).
