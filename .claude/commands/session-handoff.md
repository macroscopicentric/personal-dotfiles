Produce a session handoff summary so this work can be resumed after context compaction. Use the exact format below, filling in every field from the current conversation state. If a field doesn't apply (e.g. no hypothesis because this wasn't a debugging session), write "N/A".

---

## Session Handoff — $CURRENT_DATE

**Task:** [ticket/issue/task being worked on]
**Active skills:** [which skills governed this session, e.g. superpowers:systematic-debugging]

**Hypothesis**
- Where: [exact file, method, and line where the wrong behavior occurs]
- Why: [specific condition or code path causing it]
- Fix: [exact change needed — precise enough to write the diff from memory]
- Confirmation: [observable outcome that proves the fix worked]

**Confirmed:** [what has been verified true in this session]
**Unconfirmed:** [what is hypothesized but not yet tested]
**Blocked by:** [anything preventing progress, and why]
**Next action:** [the single next thing to do when resuming]

---

Then produce this user-fillable version for resuming the session:

```
--- RESUME HANDOFF ---
Task:
Hypothesis (where / why / fix / confirmation):
Confirmed so far:
Unconfirmed:
Blocked by:
Next action:
Active skills:
----------------------
```
