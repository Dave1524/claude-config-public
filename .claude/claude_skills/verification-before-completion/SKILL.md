---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, passing, or ready. Use before committing, creating PRs, or declaring success. Activates when tempted to say "should work" or "tests pass" without fresh evidence.
---

# Verification Before Completion

## The Iron Law

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE**

Never say "done", "fixed", "passing", or "complete" without running the actual verification command and observing the output in this session.

## The Gate Function

Before ANY completion claim, execute this 5-step process:

```
1. IDENTIFY  → Which command validates this claim?
2. EXECUTE   → Run the full command (fresh, not cached)
3. READ      → Read complete output including exit codes
4. VERIFY    → Does output actually confirm the claim?
5. CLAIM     → Only then make the claim WITH evidence
```

**Skip any step = violation.**

## What Counts as Verification

| Claim | Required Verification |
|-------|----------------------|
| "Tests pass" | Run test command, see pass count |
| "Build succeeds" | Run build, see exit code 0 |
| "Bug is fixed" | Run reproduction steps, see correct behavior |
| "Feature works" | Run feature, observe expected output |
| "Linting passes" | Run linter, see 0 errors |

## What Does NOT Count

- "I'm confident it works"
- "It should work now"
- "Based on my changes..."
- Previous run output (stale)
- Partial output or sampling
- Agent/tool reports without seeing raw output

## Red Flags - STOP Immediately

If you find yourself saying:
- "should"
- "probably"
- "seems to"
- "I believe"
- "based on the changes"
- Any satisfaction before verification

**STOP. You're about to violate the rule. Run the command first.**

## Verification Templates

### Tests
```bash
npm test              # or pytest, cargo test, etc.
# READ: X passed, Y failed
# VERIFY: Y = 0 AND X matches expected count
```

### Regression Test (Red-Green Cycle)
```
1. Write test → Run → MUST FAIL (proves test works)
2. Write fix  → Run → MUST PASS
3. Revert fix → Run → MUST FAIL (confirms fix was cause)
4. Restore    → Run → MUST PASS (final confirmation)
```

### Build
```bash
npm run build         # or cargo build, go build, etc.
# READ: Exit code
# VERIFY: Exit code = 0, not just "no linter errors"
```

### Feature Verification
```bash
# Run the actual feature
curl http://localhost:3000/api/endpoint
# READ: Response
# VERIFY: Response matches expected behavior
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I just ran it" | Stale. Run again. |
| "The code looks correct" | Looking ≠ running. Run it. |
| "It's a simple change" | Simple changes break things. Verify. |
| "I'll verify after commit" | Commit = claim of completion. Verify first. |
| "Agent said it passed" | See raw output yourself. |

## Why This Matters

Skipped verification causes:
- Shipped undefined functions
- Incomplete features marked complete
- Trust breakdown with users
- Wasted time debugging "done" code
- Reverted commits and rework

**15 seconds of verification saves hours of debugging.**

## The Mantra

```
RUN → READ → VERIFY → CLAIM
```

Never claim without evidence. Never commit without verification. Never say "done" without proof.
