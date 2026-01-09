---
name: systematic-debugging
description: Use when facing ANY technical problem - test failures, build errors, bugs, performance issues. Use ESPECIALLY when tempted to guess-and-check or when time pressure pushes toward shortcuts.
---

# Systematic Debugging

## The Iron Law

**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST**

Never propose a fix until you understand WHY the problem occurs. Guess-and-check wastes more time than investigation.

## When to Use This Most

Use this skill **especially** when:
- Time pressure creates temptation to guess
- The fix seems "obvious"
- Multiple fix attempts have already failed
- You're about to say "let's try..."

These situations require MORE investigation, not less.

## The Four Phases

```
┌─────────────────────────────────────────────────────────┐
│  INVESTIGATE → ANALYZE → HYPOTHESIZE → IMPLEMENT        │
│       │           │            │            │           │
│   Find cause   Compare    Test theory   Fix once       │
└─────────────────────────────────────────────────────────┘
```

### Phase 1: Root Cause Investigation

Before touching code:

1. **Read the error carefully** - Full message, stack trace, line numbers
2. **Reproduce consistently** - Can you trigger it reliably?
3. **Check recent changes** - What changed since it last worked?
4. **Add diagnostics** - Log at component boundaries
5. **Trace data flow** - Follow data backward from symptom to source

```bash
# Example: Add diagnostic logging
console.log('[DEBUG] Input:', JSON.stringify(input));
console.log('[DEBUG] After transform:', JSON.stringify(result));
```

### Phase 2: Pattern Analysis

Find working examples to compare:

1. **Find similar working code** - Same codebase, same pattern
2. **Study it completely** - Don't skim
3. **List every difference** - Between working and broken
4. **Document dependencies** - What does each version assume?

| Working | Broken | Difference |
|---------|--------|------------|
| Uses async/await | Uses .then() | Error handling differs |
| Validates input | Skips validation | Null can reach line 42 |

### Phase 3: Hypothesis and Testing

Form and test specific theories:

1. **Write hypothesis** - "The error occurs because X"
2. **Test ONE variable** - Change only one thing
3. **Observe result** - Did it confirm or refute?
4. **Iterate** - New hypothesis if refuted

```markdown
Hypothesis: "Timeout occurs because connection pool is exhausted"
Test: Add pool size logging before the failing call
Result: Pool shows 0 available connections → CONFIRMED
```

**If hypothesis fails:** Discard it completely. Don't stack fixes.

### Phase 4: Implementation

Only after root cause is understood:

1. **Write failing test** - Proves the bug exists
2. **Apply single fix** - Address the root cause
3. **Verify fix** - Test passes, others still pass
4. **If fix fails** - Return to Phase 1, don't try another fix

## Red Flags - STOP Immediately

If you catch yourself:
- Proposing fix before understanding cause
- Trying multiple fixes at once
- Saying "let's try..." without hypothesis
- Skipping test creation
- On 3rd fix attempt without success

**STOP. Return to Phase 1. You missed something.**

## The 3-Strike Rule

After **3 failed fix attempts**:
- Stop trying fixes
- Question the architecture
- Ask: "Is the design itself flawed?"
- Consider: refactor vs. patch

## Quick Reference

| Phase | Question to Answer | Output |
|-------|-------------------|--------|
| Investigate | What exactly is happening? | Reproduction steps, error details |
| Analyze | What's different from working code? | Comparison table |
| Hypothesize | Why is it happening? | Written hypothesis |
| Implement | Does fixing the cause fix the symptom? | Passing test |

## Common Mistakes

### Bad: Jump to Fix
```
Error: "Cannot read property 'id' of undefined"
→ "Let's add a null check"
```

### Good: Investigate First
```
Error: "Cannot read property 'id' of undefined"
→ "Where does this object come from?"
→ "It's from the API response"
→ "Let me log the raw response"
→ "Response is { data: null } when user not found"
→ "API returns null instead of 404"
→ Fix: Handle null response OR fix API
```

### Bad: Stack Fixes
```
Fix 1: Add null check → Still fails
Fix 2: Add try/catch → Still fails
Fix 3: Add timeout → Still fails
Fix 4: ???
```

### Good: Reset After Failure
```
Fix 1: Add null check → Still fails
→ Revert fix
→ Return to investigation
→ "What did I miss?"
```

## Time Comparison

| Approach | Typical Time | Success Rate |
|----------|--------------|--------------|
| Guess-and-check | 2-3 hours | ~30% first try |
| Systematic | 15-30 min | ~80% first try |

**Investigation feels slower but finishes faster.**

## The Mantra

```
UNDERSTAND → COMPARE → HYPOTHESIZE → FIX ONCE
```

Never fix what you don't understand. Never try twice without learning.
