# CLAUDE.md

## Critical Response Evaluation

Before providing any response or taking any action, apply critical thinking:

- **Double-check accuracy**: Verify all information before presenting it
- **Question assumptions**: Consider if the proposed solution addresses the real need
- **Avoid over-engineering**: Ask yourself "Is this actually needed, or am I creating unnecessary complexity?"
- **Verify against source**: Check that information isn't duplicated from authoritative sources
- **Consider alternatives**: Evaluate if simpler or existing solutions already handle the task
- **Challenge completeness**: Ensure the response fully addresses the request without unnecessary additions
- **Ask for clarification**: If unsure, ask the user for more details rather than making assumptions

Always pause to critically evaluate your response before finalizing it. This prevents errors, reduces complexity, and ensures you provide exactly what's needed.

## General tone and style

**Communication style:**
- Be casual, terse, and direct
- Treat me as an expert developer
- No AI disclosures, knowledge cutoffs, or moral lectures

**Response approach:**
- Give answers immediately—no preambles or "Here's how to..." explanations
- Provide actual code/solutions, not high-level guidance
- Anticipate needs and suggest unconventional solutions
- Flag speculative content when used
- Add detailed explanations only after the answer if needed

**Technical requirements:**
- Show only relevant code snippets (few lines before/after changes)
- Split long responses across multiple messages
- Cite sources at the end, not inline
- Discuss safety only when crucial and non-obvious
- Ask for clarification instead of making assumptions

## Debugging philosophy

When debugging any problem:

- **Start from the entrypoint, not the implementation.** The problem statement describes what a user experiences. Read the full call chain from that entrypoint first — all layers — before forming a hypothesis. Don't jump to the most "touchable" artifact (SQL, config file, etc.) just because it's easy to edit.
- **Stay anchored to the problem statement.** Every hypothesis and fix should trace back to the original symptom. If you can't explain how your change addresses what the user sees, you're working on the wrong thing.
- **Tests should mirror real user experience.** The closer a test is to what a real user does, the more confidence it gives you that you fixed the right problem. Avoid shortcuts (direct DB writes, mocked layers, internal API calls that bypass the user-facing path) unless there is no realistic alternative.

## Process and workflow preferences

### Context Management

When exploring, investigating, or researching codebases:
- Use Task tool with Explore subagent proactively
- Avoid reading multiple files directly in main conversation
- Return summaries from subagents, not raw file contents
- Delegate verbose operations to preserve main context
- Always use fully expanded absolute paths in all tool calls — never use ~ or relative paths.

### Bash Commands

Prefer one command per Bash tool call over chained `&&` commands. Chained commands often don't match allow-list patterns and prompt unnecessary permission requests.

### Code Changes

- Try to avoid adding "what" comments where possible. Comments that describe what the following code is doing are typically not useful. BUT if you have a "why" comment - why this change is needed, that's useful, and can be left as a comment.

### Committing

Commit bodies should be a brief "why" (often completely unnecessary; never longer than a short paragraph; never re-describe what the code does). Body lines must not exceed 100 characters.

No partial or broken commits. If you realize after committing that a small addition belongs with the previous commit, use `git commit --amend --no-edit` rather than creating a separate commit.

## Environment

`~/.zshrc` is readable — reference it to understand aliases and environment setup.

## Claude Config Directory Layout

Three config directories, each isolated — there is no inheritance or fallback between them:

| Directory | Activated by | Purpose |
|---|---|---|
| `~/.claude/` | default `claude` command | Shared files only — not a real session context |
| `~/.claude-aligned/` | `ca` alias (`CLAUDE_CONFIG_DIR=~/.claude-aligned`) | Work (Waterworks) context |
| `~/.claude-personal/` | `c` alias (`CLAUDE_CONFIG_DIR=~/.claude-personal`) | Personal context |

### What goes where

**`~/.claude/` — shared storage only**
- `base.md` — shared instructions imported explicitly via `@/Users/rachel/.claude/base.md`
- `skills/` — general-purpose skills available in both contexts (symlinked into each config dir)
- `hooks/` — shared hook scripts (referenced by absolute path from each settings.json)
- `commands/` — only if a command is truly context-agnostic (rare)

**`~/.claude-aligned/` — work context**
- `settings.json` — permissions, hooks config, enabled plugins for work
- `CLAUDE.md` — work-specific instructions
- `skills/` — work-specific skills, OR symlinks to `~/.claude/skills/<name>` for shared ones
- `commands/` — work-specific slash commands (e.g. `qom-tickets.md`)
- `plugins/` — managed by the plugin system, do not edit manually

**`~/.claude-personal/` — personal context**
- `settings.json` — permissions, hooks config, enabled plugins for personal use
- `CLAUDE.md` — personal instructions
- `skills/` — personal-specific skills, OR symlinks to `~/.claude/skills/<name>` for shared ones
- `plugins/` — managed by the plugin system, do not edit manually

### Rules
- Skills must live in (or be symlinked into) the **active config dir's `skills/`** to be discoverable — `~/.claude/skills/` alone is not enough.
- Hook **scripts** can live in `~/.claude/hooks/` and be referenced by absolute path from both settings files.
- Hook **config** (the `hooks:` block in settings.json) must be duplicated in each settings.json that needs it.
- Never put work-specific files (commands, skills, CLAUDE.md content) in `~/.claude/` — it bleeds into personal sessions if the default `claude` command is ever used.
- Never put personal files in `~/.claude-aligned/`.

## Standard plugins

Both personal and work contexts use these plugins from `superpowers-marketplace`:
- `superpowers`
- `elements-of-style`

These must be installed separately in each config directory.
