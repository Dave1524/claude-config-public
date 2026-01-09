---
name: test-driven-development
description: Use when implementing any feature, bugfix, refactoring, or behavior change. Use BEFORE writing implementation code. Activates when tempted to write code first and test later.
---

# Test-Driven Development

## The Unbreakable Rule

**Write the test first. Watch it fail. Write minimal code to pass.**

Production code requires a failing test first. No exceptions.

## Why Tests-First Matters

Tests written AFTER implementation provide false confidence:
- They pass immediately without proving anything
- They test what you built, not what you should build
- They miss edge cases you didn't think of

Tests written BEFORE implementation:
- Define expected behavior clearly
- Prove the test actually validates something
- Guide implementation toward requirements

## The Cycle: RED-GREEN-REFACTOR

```
┌─────────────────────────────────────────────────┐
│                                                 │
│   RED ──────► GREEN ──────► REFACTOR ──┐       │
│    │                                    │       │
│    │                                    ▼       │
│    └────────────────────────────────────┘       │
│                                                 │
└─────────────────────────────────────────────────┘
```

### RED: Write One Failing Test

Write the smallest test that demonstrates required behavior.

```typescript
test('calculates total with tax', () => {
  const result = calculateTotal(100, 0.08);
  expect(result).toBe(108);
});
```

Run it. **It MUST fail.** If it passes, you're testing existing functionality.

**Verify failure reason:** Should be "function not found" or "wrong value", NOT syntax error.

### GREEN: Write Minimal Code

Write the simplest implementation that makes the test pass. Nothing more.

```typescript
function calculateTotal(amount: number, taxRate: number): number {
  return amount + (amount * taxRate);
}
```

Run tests. **All must pass.** If not, fix until green.

### REFACTOR: Improve Code

With tests passing, improve code quality:
- Extract functions
- Rename variables
- Remove duplication

**Keep tests green throughout.** Each refactor step should pass tests.

## The Iron Law

```
CODE BEFORE TEST? DELETE IT. START OVER.
```

**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

## Red Flags - STOP and Start Over

If you catch yourself:
- Writing implementation before test
- "I'll test it after"
- "It's too simple to need a test"
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "It's about spirit not ritual"

**STOP. Delete any code. Write the test first.**

## Verification Checklist

Before claiming implementation complete:

- [ ] Each function has a test
- [ ] Witnessed each test fail first
- [ ] Failures were from missing features (not syntax errors)
- [ ] All tests pass with clean output
- [ ] Uses real code, minimal mocking

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Manual testing covered it" | Manual tests aren't repeatable. Automate. |
| "It's about spirit not ritual" | Violating the letter IS violating the spirit. |
| "I know it works" | You know nothing until a test proves it. |
| "Testing slows me down" | Debugging untested code slows you more. |

## Quick Reference

| Phase | Action | Verification |
|-------|--------|--------------|
| RED | Write test | Run → FAIL |
| GREEN | Write code | Run → PASS |
| REFACTOR | Improve | Run → still PASS |

## Anti-Patterns

See testing-anti-patterns.md for detailed anti-patterns:
- Testing mock behavior instead of real code
- Adding test-only methods to production
- Mocking without understanding
- Incomplete mock responses
- Tests as afterthought

## The Mantra

```
TEST → FAIL → CODE → PASS → REFACTOR → REPEAT
```

Never write production code without a failing test. Never claim code works without seeing the test pass.
