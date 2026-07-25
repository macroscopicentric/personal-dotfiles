# Build Voice Profile

Build a `write-like-me` skill by analyzing a user's writing corpus. The output is a SKILL.md file that teaches Claude to write in the user's voice.

## Step 1: Discover available sources

Check what's available and present options to the user. Run these checks silently, then present a single interactive question.

**Probe for all of these** — don't assume any are available, including git and local files:
- **Git history** — run `git rev-parse --is-inside-work-tree` in the working directory. If true, offer it. The user will need to confirm their author name/email.
- **Markdown/text files** — ask if the user has a directory of their writing (blog posts, notes, docs, journal entries). Don't assume one exists.
- **Pasted text** — always offer this as an option.
- **Slack** — use ToolSearch to check for `mcp__claude_ai_Slack__slack_search_public` or similar. Only offer if found.
- **Obsidian** — use ToolSearch to check for `mcp__obsidian__search-vault` or similar. Only offer if found.
- **Notion** — use ToolSearch to check for `mcp__notion__notion-search` or similar. Only offer if found.
- **Google Drive** — use ToolSearch to check for `mcp__claude_ai_Google_Drive__*`. Only offer if found.

Present a multi-select question: "Which sources should I pull from?" listing only the ones actually available. Include "Other (I'll provide files/text)" as a catch-all.

## Step 2: Gather corpus

For each selected source, collect writing samples interactively:

### Git
- Ask for author name/email and repo path(s) if not obvious
- Run `git log --author="<name>" --format="---commit---%n%s%n%b" -200` to get recent commits
- Also check for PR descriptions if `gh` is available: `gh pr list --author=<user> --state=all --limit=50 --json title,body`
- Separate commit titles from bodies — they may represent different registers

### Markdown/text files
- Ask for the directory path
- Read files (respect a reasonable limit — sample ~20-30 files, prioritize variety over volume)
- Note the filenames/paths — they hint at register (e.g., `journal.md` vs `tech-spec.md`)

### Slack (via MCP)
- Ask which channels or search terms to use
- Pull ~50-100 messages
- Filter to substantive messages (skip single-emoji reactions, very short "ok"/"thanks")

### Obsidian (via MCP)
- Ask which vault and any search terms
- Pull ~20-30 notes, sampling across folders

### Notion (via MCP)
- Ask what to search for
- Pull ~20-30 pages

### Pasted text / other
- Ask the user to paste samples or point to files
- For unknown formats, try to parse as plain text — split on double newlines as separate samples
- If the format is structured (JSON, CSV), ask the user which field contains the writing

### General rules for gathering
- Don't dump raw corpus into the conversation — summarize what you collected ("got 150 commit messages, 23 blog posts, 80 Slack messages")
- If a source fails or is empty, say so and move on
- Ask the user to label sources by register/context if it's not obvious ("are these Slack messages work or personal?")

## Step 3: Propose registers

Before analyzing patterns, propose a set of **registers** — distinct writing voices the user switches between depending on context. Most people have 2-4.

### What registers are

A register is a consistent voice you use in a specific context. Most people shift how they write depending on audience and stakes without thinking about it. Examples:

- You might write a Slack message to a coworker very differently from a performance review
- Commit messages might be terse and imperative while design docs are structured and hedged
- Personal journal entries might be lowercase stream-of-consciousness while client emails are polished

The goal is to identify these shifts so Claude can match the right voice to the right context.

### How to propose registers

Based on the corpus sources gathered, start with two registers:

| Register | Typical contexts | What makes it different |
|----------|-----------------|----------------------|
| **Formal** | Tech specs, design docs, performance reviews, external-facing docs, work commits | Complete sentences, proper capitalization, structured sections, careful hedging |
| **Informal** | Slack messages, personal notes, journal entries, personal project commits, DMs | Fragments OK, lowercase OK, shortcuts, humor, stream-of-consciousness |

Some people write the same way everywhere — that's one register, and that's fine. Only propose a third register (e.g., semi-formal) if you see clear evidence in the corpus of a middle voice that doesn't fit neatly into either formal or informal, or if the user asks for finer-grained splits.

### Confirm with the user

Present your proposed registers with:
- A name for each
- 2-3 example contexts where it applies
- A one-sentence description of how it differs from the others
- 1-2 real examples from their corpus that illustrate the register

Then ask:
- "Does this split feel right, or do you write differently in some of these contexts?"
- "Are there contexts I'm missing or grouping wrong?"
- "Is there a register you'd consider your 'default' — the one Claude should use when the context isn't clear?"

Do NOT proceed to pattern analysis until the user confirms or corrects the registers. This is the structural backbone of the skill — getting it wrong means every example and pattern lands in the wrong bucket.

## Step 4: Analyze patterns

For each confirmed register, identify:

1. **Capitalization** — sentence case? lowercase? "I" vs "i"?
2. **Punctuation** — periods at end of sentences? em-dashes? semicolons? Oxford comma? exclamation points?
3. **Sentence structure** — fragments OK? comma splices? average length? parenthetical asides?
4. **Hedging/confidence markers** — "i think", "probably", "feels like", "clearly", "obviously"?
5. **Tone markers** — humor? sarcasm? self-deprecation? earnestness? directness?
6. **Openers** — how do messages/paragraphs typically start? ("I", action verb, question, observation?)
7. **Vocabulary** — any distinctive words, abbreviations, or phrases that recur?
8. **Structure** — bullets vs prose? headers? how are longer pieces organized?
9. **Anti-patterns** — what does the user clearly NOT do? (no corporate-speak? no emoji? no exclamation points?)

Present your analysis to the user for review before generating the skill. Ask: "Does this sound right? Anything I'm missing or getting wrong?"

## Step 5: Generate the skill

Produce a SKILL.md following this structure:

```markdown
---
name: write-like-me
description: Use when writing anything in [user]'s voice. [Brief description of registers and when to use each.]
---

# Write Like Me

[Register table — map output contexts to registers]

[Shared traits across all registers]

---

## [Register Name] (default)

**Use for:** [contexts]

**Voice:** [description of patterns]

### [Sub-context] (real corpus)

[5-10 real examples from the corpus, with pattern annotations below]

---

[Repeat for each register]

---

## Quick Reference

[Context → Register → Key traits table]

## Anti-patterns (all registers)

[List of things the user clearly avoids]
```

Rules for the generated skill:
- Use REAL examples from the corpus, not invented ones
- 2-4 registers is typical — don't over-segment
- The default register should be the one the user confirmed as default in Step 3
- Anti-patterns are as important as patterns — they prevent Claude from falling back to its own voice
- Keep it under 300 lines — this is a reference, not a novel

## Step 6: Save and install

Ask the user where to save the skill. Default suggestion: `~/.claude/skills/write-like-me/SKILL.md` (shared across contexts).

Remind them:
- The skill needs to be in (or symlinked into) their active config dir's `skills/` to be discoverable
- They can invoke it with `/write-like-me` or it'll be used automatically when the description matches

If they want it in a repo for version control, suggest creating a small repo with the SKILL.md and a README explaining how to install it.
