# todoGuide

A guide to the [vibestack](https://github.com/vibestackmd/vibestack) framework -- an opinionated convention system for AI-assisted development with Claude Code.

## Read the Book

The published book is available at: *[GitBook link coming soon]*

## About

This repo contains the source content for a GitBook that covers:

- **Getting Started** -- what vibestack is, how to install it, your first run
- **Core Concepts** -- CLAUDE.md, TODO.md, ops.sh, and the docs convention
- **Skills** -- how to use and create skills (/vibestack, /todo, /squad, /docs, /bosskey)
- **Workflows** -- patterns for solo developers and teams
- **Advanced** -- squad mode, CI guards, settings, hooks, and troubleshooting

## Project Structure

```
book/           # GitBook content (chapters organized by section)
docs/           # Internal project docs (vibestack convention)
ops.sh          # Project CLI (build, test, run, status)
TODO.md         # Task tracker
.claude/        # Claude Code skills and settings
```

## Development

```bash
# Check for broken links
./ops.sh test

# Serve book locally
./ops.sh run

# Show book stats
./ops.sh status
```

## License

MIT
