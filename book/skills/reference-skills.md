# Reference Skills (cli-first, lsp)

Reference skills are background knowledge that Claude loads automatically when relevant. They are not slash commands -- you never type `/cli-first` or `/lsp`. Instead, Claude reads their descriptions and pulls them in when the conversation topic matches.

Think of reference skills as conventions written down once so you never have to explain them again. Every time Claude interacts with an external service, the `cli-first` skill reminds it to use CLI tools instead of web dashboards. Every time Claude does a cross-file refactor, the `lsp` skill reminds it to use language server tools instead of guessing from grep results.

## cli-first

### The Philosophy

When Claude needs to interact with a third-party service -- deploying to Vercel, querying a database, configuring a Stripe webhook -- it should use the CLI tool, not visit a web dashboard, not make raw HTTP calls, and not suggest you go click through a UI.

CLI tools give you:

- **Reproducibility.** A CLI command can be scripted and repeated. A sequence of dashboard clicks cannot.
- **Full control.** CLIs expose more functionality than web UIs, and they're often more up-to-date.
- **Agent compatibility.** Claude can execute CLI commands directly. It cannot click buttons on a webpage.

### Environment Variables

Before making any API call, Claude checks your `.env*` files for existing credentials and configuration:

```bash
# Checked in this order:
# 1. .env.local     -- local overrides (gitignored, highest priority)
# 2. .env           -- shared project defaults
# 3. .env.development / .env.production -- environment-specific
```

Claude looks for API keys, access tokens, project IDs, region settings, database connection strings, and service-specific configuration like bucket names or queue URLs.

The hard rule: never hardcode credentials. If a needed credential is not in `.env*`, Claude asks you to add it rather than creating one or embedding it in source code.

### Common CLIs

The `cli-first` skill covers these tools:

| Service | CLI | Common Uses |
|--|--|--|
| AWS | `aws` | S3, Lambda, CloudFormation, IAM, ECR, ECS |
| Vercel | `vercel` | Deploy, env vars, domains, project settings |
| Supabase | `supabase` | DB migrations, edge functions, auth config |
| GitHub | `gh` | Issues, PRs, releases, Actions, repo settings |
| Stripe | `stripe` | Webhooks, test events, product/price setup |
| Google Cloud | `gcloud` | Compute, Cloud Run, IAM, storage, pub/sub |
| Firebase | `firebase` | Hosting, Firestore rules, functions |
| Cloudflare | `wrangler` | Workers, KV, R2, DNS |

### The Workflow

When Claude needs to use an external service, it follows this sequence:

1. **Check if the CLI is installed.** Run `command -v <tool>` or `which <tool>`.
2. **Check `.env*` files** for project credentials and configuration.
3. **Check auth status.** Most CLIs have a `whoami` or `status` command.
4. **Use the CLI** to perform the operation.
5. **If the CLI is not installed**, suggest you install it rather than working around it with raw HTTP calls.

In practice, this means Claude runs commands like these instead of sending you to a dashboard:

```bash
# Add an environment variable to Vercel
vercel env add MY_SECRET production

# Upload files to S3
aws s3 cp ./dist s3://my-bucket/ --recursive

# Run a Supabase migration
supabase db push

# Create a GitHub release with auto-generated notes
gh release create v1.0.0 --generate-notes

# Forward Stripe webhooks to local dev server
stripe listen --forward-to localhost:3000/api/webhooks
```

## lsp

### When to Use It

The `lsp` skill tells Claude to use language server tools (LSP) -- programs that understand code semantically, not just as text -- for tasks where grep falls short:

- **Finding all references** to a function, type, or variable across the codebase
- **Go-to-definition** to understand what a symbol actually is, especially when it's imported through multiple layers
- **Type checking** to catch errors the way CI will, before declaring a refactor done
- **Understanding inferred types** that are not written explicitly in source code
- **Call hierarchy** -- who calls this function, and what does it call
- **Rename safety** -- verifying all usages before a cross-file rename

For simple, single-file edits where you can read the code directly, LSP is overkill. It's most valuable during refactors that touch multiple files.

### Tools by Language

Each language has its own CLI type-checker that Claude uses:

**TypeScript / JavaScript:**

```bash
# Type-check the entire project
npx tsc --noEmit

# Type-check with formatted output
npx tsc --noEmit --pretty 2>&1
```

The TypeScript language server also provides hover (inferred types), go-to-definition, find-all-references, safe rename, and signature help.

**Python:**

```bash
# Full type-check with structured JSON output
pyright src/ --outputjson

# Human-readable output
pyright src/

# Check a single file
pyright src/auth/handler.py
```

Pyright catches missing imports, wrong argument types, unresolved attributes, incorrect return types, and None-safety issues.

**Rust:**

```bash
# Type-check the project
cargo check --message-format=json 2>&1

# Deeper analysis with clippy (lint + type issues)
cargo clippy --message-format=json 2>&1
```

The Rust language server adds trait implementation lookup, macro expansion, and lifetime analysis.

**Go:**

```bash
# Type-check and vet
go vet ./...

# Build check without producing a binary
go build ./...
```

The Go language server adds interface implementation lookup and package-wide symbol search.

### The Workflow

Claude uses LSP tools at three points during a refactor:

1. **Before starting** -- use references and definitions to map the blast radius. Know every file that will be affected before changing anything.
2. **During implementation** -- use hover and signature help when unsure about types or APIs. Don't guess when the language server can give an exact answer.
3. **After changes** -- run the type checker to verify correctness. `tsc --noEmit`, `pyright`, `cargo check`, or `go vet`. This catches errors that reading files alone cannot.

### The Rules

Two rules govern when Claude reaches for which tool:

- **Prefer LSP over grep for semantic queries.** Grep finds text. LSP understands code. "Find all references to `UserSession`" via LSP will not false-match comments, strings, or identically named symbols in different scopes.
- **Prefer CLI type-checkers for validation.** After making changes, run the project's type checker. This is the same check CI will run, so if it passes locally, it will pass in the pipeline.

Scope narrowly when possible. Check one file or directory first, not the whole project, unless you need full-project diagnostics.
