# Writing Custom Skills

Skills are how you teach Claude things specific to your project. If you find yourself explaining the same convention repeatedly, or if you have a multi-step workflow you run regularly, write a skill. Claude will follow it every time, without you having to re-explain.

## When to Write a Skill

Write a skill when:

- **You keep explaining the same convention.** If you've told Claude three times that all API errors should use your custom `AppError` class, write a reference skill so it knows going forward.
- **You have a repeatable multi-step workflow.** If deploying to staging always involves the same five commands in the same order, write a task skill so you can trigger it with one slash command.
- **You want consistent behavior across sessions.** Skills persist. Conversation instructions don't. Anything that should survive between sessions belongs in a skill.

## Reference vs. Task

There are two types of skills, and the distinction matters:

**Reference skills** are background knowledge. Claude reads them automatically when the topic is relevant. You never invoke them directly -- they just inform how Claude behaves.

- `user-invocable: false`
- No slash command
- Claude loads them based on the `description` field

Use reference skills for: coding conventions, error handling patterns, API design rules, testing expectations, naming conventions.

**Task skills** are workflows you trigger with a slash command. You type `/skill-name` and Claude executes the steps.

- `user-invocable: true`
- Shows up in the `/` autocomplete menu
- Often uses `disable-model-invocation: true` so only you can trigger it

Use task skills for: deployment workflows, code audits, migration steps, report generation, cleanup routines.

## Creating a Skill

Every skill lives in its own directory under `.claude/skills/` and requires a `SKILL.md` file:

```bash
mkdir -p .claude/skills/my-skill
```

Create `.claude/skills/my-skill/SKILL.md` with YAML frontmatter and markdown instructions:

```yaml
--
name: my-skill
description: What this skill does and when Claude should use it
user-invocable: true
--

# My Skill

Instructions that Claude follows when this skill is active.
```

The directory can also contain supporting files:

```
.claude/skills/my-skill/
  SKILL.md          # Required -- frontmatter + instructions
  reference.md      # Optional -- detailed docs Claude can read
  templates/        # Optional -- templates, examples, scripts
```

## Frontmatter Reference

The YAML frontmatter at the top of `SKILL.md` controls how the skill behaves:

| Field | Purpose | Example |
|--|--|--|
| `name` | Slash command name (lowercase, hyphens) | `deploy-staging` |
| `description` | Tells Claude when to load this skill | `"Deploy the app to the staging environment"` |
| `disable-model-invocation` | Only the user can trigger it (not Claude on its own) | `true` |
| `user-invocable` | Whether it appears in the `/` menu | `false` for reference skills |
| `allowed-tools` | Pre-approve specific tools so Claude doesn't ask permission | `Read, Grep, Bash(cargo *)` |
| `argument-hint` | Hint shown in autocomplete | `[environment]` |
| `context` | Run in an isolated context | `fork` |

The `description` field is the most important for reference skills. Claude uses it to decide whether to load the skill. Write it as if answering "when should Claude read this?" -- for example, `"Convention for error handling in API route handlers. Auto-loads when working with error responses or exception handling."`.

## Using Arguments

When someone invokes a task skill with arguments, those arguments are available inside the skill content as variables.

If a user types:

```
/deploy-staging us-east-1 --verbose
```

The skill content can reference:

| Variable | Value |
|--|--|
| `$ARGUMENTS` | `us-east-1 --verbose` |
| `$0` | `us-east-1` |
| `$1` | `--verbose` |

Use them directly in your skill instructions:

```yaml
--
name: deploy-staging
description: Deploy the app to a staging environment in the specified region
user-invocable: true
disable-model-invocation: true
argument-hint: [region]
--

# Deploy to Staging

Deploy the application to the staging environment in the **$0** region.

## Steps

1. Run `./ops.sh build`
2. Run `./ops.sh test`
3. Run `aws ecs update-service --cluster staging --region $0 --force-new-deployment`
4. Run `./ops.sh status` and confirm the deployment is healthy
5. Report the deployment status to the user
```

If `$ARGUMENTS` is not referenced anywhere in the skill content, Claude Code appends it to the end automatically.

## Example: Reference Skill

Here is a reference skill that teaches Claude your project's error handling conventions:

```yaml
--
name: error-handling
description: Conventions for error handling in API route handlers. Auto-loads when working with error responses, try/catch blocks, or exception handling.
user-invocable: false
--

# Error Handling Conventions

All API route handlers use the `AppError` class for error responses.

## Rules

- Never throw raw `Error` objects from route handlers. Always use `AppError`.
- Include an error code (string) and HTTP status (number) with every error.
- Log the full error with stack trace server-side. Return only the code and
  message to the client.

## Pattern

    import { AppError } from "@/lib/errors";

    export async function POST(req: Request) {
      try {
        const body = await req.json();
        // ... handler logic
      } catch (err) {
        if (err instanceof AppError) {
          return Response.json(
            { error: err.code, message: err.message },
            { status: err.status }
          );
        }
        console.error("Unexpected error:", err);
        return Response.json(
          { error: "INTERNAL_ERROR", message: "Something went wrong" },
          { status: 500 }
        );
      }
    }
```

Claude loads this skill whenever it sees you working on route handlers or error handling. You never invoke it -- it just shapes how Claude writes error-handling code in your project.

## Example: Task Skill

Here is a task skill for deploying to staging with specific verification steps:

```yaml
--
name: deploy-staging
description: Build, test, and deploy the app to the staging environment
user-invocable: true
disable-model-invocation: true
allowed-tools: Bash(./ops.sh *), Bash(aws *), Read
argument-hint: ""
--

# Deploy to Staging

## Steps

1. Run `./ops.sh build` and verify it succeeds
2. Run `./ops.sh test` and verify all tests pass
3. Run `./ops.sh deploy staging` to push the build
4. Wait 30 seconds, then run `./ops.sh status` to confirm the deployment
   is healthy
5. If any step fails, stop and report the error. Do not continue deploying
   a broken build.

## Post-Deploy

After a successful deploy, report:
- Build duration
- Number of tests passed
- Deployment target and region
- Health check status
```

You trigger this with `/deploy-staging` and Claude executes each step, stopping if anything fails.

## Personal vs. Project Scope

Skills can live in two places:

| Location | Scope | Use When |
|--|--|--|
| `.claude/skills/` | This project only | Conventions specific to one codebase |
| `~/.claude/skills/` | All your projects | Personal workflows you use everywhere |

Project skills are checked into version control. Everyone on the team gets them. Personal skills live in your home directory and follow you across every project.

If a personal skill and a project skill have the same name, the personal skill takes priority.

## Tips

- **Keep skills focused.** One skill, one job. A skill that tries to cover error handling, logging, and testing conventions is three skills pretending to be one.
- **Test your skills.** After writing a skill, invoke it (or trigger the context it loads for) and verify Claude follows the instructions correctly. Adjust wording if it misinterprets something.
- **Update when conventions change.** Skills are only useful if they reflect current practice. When you change an error handling pattern or switch deployment targets, update the corresponding skill.
- **Use `allowed-tools` to speed things up.** If your deploy skill always needs Bash and Read, pre-approve them in the frontmatter so Claude does not ask for permission on every step.
- **Start small.** You don't need to write skills for everything on day one. Wait until you notice yourself repeating an explanation or a workflow, then write the skill. The best skills come from real friction, not speculation.
