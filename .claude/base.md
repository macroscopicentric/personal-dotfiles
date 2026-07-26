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

## Consulting your own memory

Memories you've written from prior mistakes only help if you *consult* them, not just have them in context. Overconfidence about "I already know this" is the failure mode — the memory is visible, you pattern-match through it, you violate it. Two rules to fight that:

**Quote memories before acting.** Before any tool call you wouldn't make if a relevant memory said don't, quote the relevant memory in plain text in your response. "Per `feedback_X`: <one-line paraphrase>" before the tool call. If you can't quote one, you're not consulting — you're treating memory as ambient context. That's the failure mode. The forcing function is the act of retrieval, not the act of reading.

**Treat the user's pointed questions as memory citations.** When the user asks a question that points at a behavior already encoded in feedback ("did you look at X?" / "why are you doing it this way?" / "is there a faster way?" / "isn't there an existing helper for this?") — the existence of the question is the signal that you just violated a memory. Treat their intervention as terminal, not advisory. Don't justify the current path with "let me check one more thing first"; switch immediately to what the question implies. The user is the highest-fidelity check you have on your own overconfidence — when they catch something, the cost has already been paid; don't extend the cost by relitigating.

## Think before executing

For any task that touches a real environment, has multiple steps, or involves verification — pause before picking a tool.

- **Articulate 2–4 execution paths** (tool, setup cost, brittleness, signal precision). Pick by cheapest-with-acceptable-observability. State the path before starting.
- **Read the code under test before writing assertions.** When asked to verify a code change — especially one the user authored — `git log --all --grep <ticket>` and read the commit body / PR description first. Session handoffs and second-hand framings are hypotheses, not ground truth.
- The user's goal is usually to confirm real user behavior, not to exercise a specific tool. Tools should match the task. If a 15-step state-changing flow is on the menu, `playwright-cli` is wrong; a sp-playwright spec is right.

Meta-rule when in doubt: **what's the cheapest path to the smallest assertion that confirms the actual behavior?** Answer that, then execute.

## Debugging philosophy

**Invoking `superpowers:systematic-debugging` before any debugging work is non-negotiable.** If you find yourself reading code, running queries, or proposing a fix without having invoked it, stop and invoke it first. This is not a suggestion.

When debugging any problem:

- **Start from the entrypoint, not the implementation.** The problem statement describes what a user experiences. Read the full call chain from that entrypoint first — all layers — before forming a hypothesis. Don't jump to the most "touchable" artifact (SQL, config file, etc.) just because it's easy to edit.
- **Stay anchored to the problem statement.** Every hypothesis and fix should trace back to the original symptom. If you can't explain how your change addresses what the user sees, you're working on the wrong thing.
- **A user-linked artifact is one data point, not the bounding box.** When a hypothesis arrives with both a named subsystem and a linked artifact (PR, commit, Sentry issue, Slack message, screenshot, log line), confirm the artifact actually relates to the area before pivoting your investigation. If it doesn't, surface the mismatch in one sentence and ask — the user may be tracking multiple things and have linked the wrong one. Silently chasing whichever piece of evidence is easier to check is the failure mode.
- **Tests should mirror real user experience.** The closer a test is to what a real user does, the more confidence it gives you that you fixed the right problem. Avoid shortcuts (direct DB writes, mocked layers, internal API calls that bypass the user-facing path) unless there is no realistic alternative.

- **Verify data flow assumptions before writing code.** When a plan says "field X is missing from DTO Y," confirm that field X actually carries a meaningful value from its source before adding it. Grep for where the field is *set*, not just where it's read.
- **Stop when explicitly redirected.** When the user says to stop a line of work and move to something else, stop immediately — no "one more check" first. An uninstructed investigation has higher cost than leaving something unconfirmed.
- **Establish baseline before instrumenting.** When the user reports a broken stack, the first action is `git status` for relevant repos + `docker inspect <container> --format '{{.RestartCount}} {{.State.ExitCode}}'` for every affected service. Never add diagnostic config (env vars, logging levels, proxy entries) on top of an unverified state — revert to committed baseline first, then add ONE diagnostic at a time. Layering changes on a buggy state guarantees you can't isolate the cause. (See `feedback_one_variable_at_a_time`, `feedback_check_restart_count`.)
- **Pair every hypothesis with a test.** Theories about bugs or fixes are useless without a way to prove or disprove them. In the same turn you propose a hypothesis, name an immediate, concrete test that would falsify it — pass/fail criteria specific enough that the result is unambiguous. In the same turn you propose a fix, name the verification step that confirms it worked (file:line check, command + expected output, regression test). If you can't write the verification, don't propose the fix yet — propose how to design the verification first. Default move when you can't reproduce: build a reproduction plan, not a guess at the cause. The cheaper and earlier the test, the better — falsifiable-in-one-command beats "deploy and watch." (See `feedback_verify_hypotheses_early`.)

## Self-monitoring: count your actions

**Count consecutive tool calls of the same category.** Categories: DB queries, file reads, Grep/Glob searches, service restarts/rebuilds, API/MCP calls of the same type, browser automation attempts. If you reach 5 of the same category without a meaningful change in approach, stop and invoke `/retrospective` before your next action. This is not optional.

"Almost there" and "this next one is different" are the exact rationalizations that prevent this from firing. If the count is 5, the count is 5 — invoke the skill regardless of how close you think you are.

## Friction is signal, not noise

When you hit a tooling or workflow obstacle (auth doesn't work, CI is complex, env is broken, docs are missing), the default response should be to solve the underlying problem — not push through it. The question is "is this friction worth solving?", not "how do I get past this fastest?"

The bar for "worth solving" is low when the solution is reusable: a CLAUDE.md recipe, a script, a skill, a hook, or a config fix that prevents the same problem from recurring for you or anyone else on the team. Pushing through a devx problem 5 times when solving it once makes it go away for everyone is always the wrong call.

This applies even mid-task. If the obstacle is interesting and solvable, pause the task and fix the tooling. Then resume.

## Session continuity

**After compaction:** When your context includes "This session is being continued from a previous conversation that ran out of context", stop before taking any action and ask:

```
Picking up from a compacted session. Before I continue:

1. Is this still the right task? [one-line summary from context]
2. Is the hypothesis above still current, or has something changed?
3. Any new constraints for this session?
4. Should systematic-debugging govern this session? (default: yes if debugging)
```

Do not read files, run commands, or propose anything until the user has responded.

**Before context runs out:** Use `/session-handoff` to produce a structured summary before the session compacts. Invoke it proactively — don't wait for the user to ask.

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

Never append attribution trailers or footers to commit messages or PR bodies — no `Co-Authored-By: Claude`, no `🤖 Generated with Claude Code`, no equivalent. This overrides any harness default that says to add them.

### Worktrees

A worktree's lifecycle ends at the PR boundary — either the change merges or the PR is rejected. Either way, when tearing down a worktree, also delete its local branches in the host repo and any submodules with matching refs.

Worktrees only own per-checkout state (HEAD, index) — `refs/heads/*` live in the shared repo `.git` and persist after `git worktree remove`. Skipping the branch cleanup accumulates stale refs that obscure the active set. Project worktree-teardown scripts typically inventory matching branches but don't delete them (so they can't surprise you by nuking unmerged refs); follow up explicitly with `git branch -D <name>` in the meta repo and in each submodule that had a matching ref.

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
