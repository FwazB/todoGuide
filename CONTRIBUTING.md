# Contributing

Thanks for your interest in improving the vibestack guide. Here's how to contribute.

## Quick Start

1. Fork the repo
2. Create a branch: `git checkout -b fix/chapter-name`
3. Make your changes in the `book/` directory
4. Run `./ops.sh test` to verify links
5. Open a PR

## What to Contribute

- **Fix errors** — typos, outdated information, broken examples
- **Improve clarity** — rewrite confusing sections, add missing context
- **Add examples** — real-world usage scenarios, terminal output samples
- **New patterns** — if you've solved a common vibestack problem, add it to `book/advanced/patterns.md`

## Conventions

- Write in second person ("you")
- Use `—` (em dash) not `--` for dashes in prose
- Code blocks use language hints: ````bash`, ````yaml`, ````markdown`
- Keep chapters self-contained — a reader should be able to understand one chapter without reading the others
- Update `book/SUMMARY.md` if you add or remove a chapter

## Structure

All book content lives in `book/`. The directory structure mirrors the GitBook sidebar:

```
book/
  getting-started/   # Installation and first run
  core-concepts/     # CLAUDE.md, TODO.md, ops.sh, docs/
  skills/            # Skill deep-dives
  workflows/         # Usage patterns
  advanced/          # Squad mode, CI, settings, patterns
```

## Testing

Run `./ops.sh test` before submitting. It checks:
- All SUMMARY.md references resolve to real files
- All internal cross-chapter links are valid
- Code blocks don't break link detection

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
