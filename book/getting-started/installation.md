# Installation

vibestack installs in under a minute. It drops convention files into your project directory and optionally sets up dev tools. Nothing is compiled, nothing runs in the background, and nothing changes your existing code.

## Prerequisites

- **Claude Code** — installed and working (`claude` or `claw` available in your terminal)
- **Git** — your project should be a git repo (or you're about to make it one)
- **Bash** — the installer is a shell script

## Install

Navigate to your project directory and run:

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/vibestackmd/vibestack/main/install.sh | bash
```

The installer does three things:

1. **Copies convention files** into your project — `CLAUDE.md`, `TODO.md`, `ops.sh`, `docs/`, and `.claude/skills/`
2. **Asks about dev tools** — offers to install helpful CLI tools like `jq`, language servers, and platform CLIs (you can skip any of them)
3. **Sets up the `claw` alias** — a shortcut for launching Claude Code with the right settings

### What Gets Created

```
your-project/
  CLAUDE.md                    # Project reference (template — you'll fill it in)
  TODO.md                      # Task tracker (starts with one example task)
  ops.sh                       # Project CLI (template — you'll configure it)
  docs/
    README.md                  # Docs convention guide
    SUMMARY.md                 # Table of contents
    index.md                   # Landing page (template)
    skills-and-commands.md     # Guide to creating skills
  .claude/
    settings.json              # Pre-approved permissions + hooks
    hooks/
      notify-done.sh           # Audio alert when Claude finishes
      statusline.sh            # Status bar info
    skills/
      vibestack/SKILL.md       # /vibestack — project setup
      todo/SKILL.md            # /todo — task runner
      squad/SKILL.md           # /squad — domain specialists
      docs/SKILL.md            # /docs — doc maintenance
      bosskey/SKILL.md         # /bosskey — standup generator
      cli-first/SKILL.md       # Reference: CLI-first conventions
      lsp/SKILL.md             # Reference: language server usage
```

### Smart Merging

If you already have a `CLAUDE.md` or other files, the installer won't overwrite them. It merges new content with your existing files so you don't lose any work.

## The `claw` Alias

The installer offers to create a `claw` alias in your shell config (`.bashrc` or `.zshrc`). This is just a convenience — it launches Claude Code the same way `claude` does, but the shorter name is faster to type and signals that you're using vibestack conventions.

```bash
# These are equivalent:
claude
claw
```

If you skip the alias during install, you can add it later:

```bash
echo 'alias claw="claude"' >> ~/.zshrc
source ~/.zshrc
```

## Plugin Mode

If you prefer not to use the curl installer, you can install vibestack as a Claude Code plugin from within a Claude session:

```
/plugin install vibestackmd/vibestack
```

This does the same thing as the curl install — drops the convention files into your project — but runs from inside Claude Code instead of your shell.

## Dev Tools (Optional)

During installation, the script offers to install development tools that vibestack skills rely on. These are all optional — say no to any you don't need.

Common tools it offers:

- **jq** — JSON processor (used by some skills for parsing output)
- **Language servers** — TypeScript (`typescript-language-server`), Python (`pyright`), etc. for the `lsp` skill
- **Platform CLIs** — `gh` (GitHub), `aws`, `vercel`, `supabase`, etc. for the `cli-first` skill
- **libpq** — PostgreSQL client library (if your project uses Postgres)

You can always install these later. The skills will work without them — they'll just suggest you install the relevant tool when they need it.

## Verify the Install

After installation, check that everything landed:

```bash
ls -la CLAUDE.md TODO.md ops.sh docs/ .claude/
```

You should see all the files listed above. If anything is missing, re-run the installer — it's safe to run multiple times.

## Next Steps

With the files in place, launch Claude Code and run `/vibestack` to configure everything for your specific project. See [Your First Run](first-run.md) for the full walkthrough.
