---
name: executing-plans
description: Use when you have a written implementation plan ready to execute. Use for structured batch execution with review checkpoints between phases.
---

# Executing Plans

## Overview

**Core principle:** Batch execution with checkpoints for architect review.

Execute plans in small batches (~3 tasks), verify results, report to user, and wait for feedback before continuing.

## When to Use

**Use this skill when:**
- You have a detailed implementation plan (from `writing-plans`)
- Work spans multiple phases needing user review
- Tasks require verification before proceeding

**Do NOT use when:**
- No written plan exists (create one first)
- Single simple task (just do it)
- Exploratory work without clear steps

## The Five-Step Process

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│   LOAD → EXECUTE BATCH → REPORT → CONTINUE → COMPLETE   │
│           ↑                          │                   │
│           └──────────────────────────┘                   │
│                  (repeat)                                │
└──────────────────────────────────────────────────────────┘
```

### Step 1: Load and Review

Before starting:

1. Read the entire plan file
2. Identify all tasks and their order
3. Note any dependencies between tasks
4. Raise concerns BEFORE starting

```markdown
## Plan Review

Plan: docs/plans/2024-01-15-user-auth.md
Tasks: 8 total
Dependencies: Task 4 requires Task 3
Concerns: None identified

Ready to begin execution.
```

**If concerns exist:** Stop and discuss with user before proceeding.

### Step 2: Execute Batch

Work through ~3 tasks per batch:

For each task:
1. Mark as `in_progress` in TodoWrite
2. Follow plan steps EXACTLY
3. Run specified verifications
4. Mark as `completed` when verified

```markdown
## Batch 1 Progress

Task 1: Add profiles schema ✓
- Migration created
- Test passes: "profiles table exists"

Task 2: Create signup action ✓
- Server action implemented
- Test passes: "creates user and profile"

Task 3: Add signup form ✓
- Component created
- Test passes: "renders form fields"

Batch 1 complete. Ready to report.
```

### Step 3: Report

After each batch, present:

1. What was completed
2. Verification results (test output)
3. Any issues encountered
4. "Ready for feedback"

```markdown
## Batch 1 Report

### Completed
- Task 1: profiles schema ✓
- Task 2: signup action ✓
- Task 3: signup form ✓

### Verification
All tests passing (3/3)

### Issues
None

**Ready for feedback before continuing to Batch 2.**
```

**Wait for user response.** Do NOT continue autonomously.

### Step 4: Continue

After user feedback:

1. Incorporate any requested changes
2. Execute next batch of ~3 tasks
3. Report results
4. Repeat until plan complete

### Step 5: Complete

When all tasks done:

1. Run full test suite
2. Verify all acceptance criteria
3. Present completion options:
   - Commit changes
   - Create PR
   - Keep for further review

## Critical Stopping Points

**STOP immediately if:**

| Blocker | Action |
|---------|--------|
| Missing dependency | Ask user how to proceed |
| Test fails | Investigate before continuing |
| Unclear instruction | Ask for clarification |
| 2+ verification failures | Report and wait for guidance |

**Never guess.** Ask for clarification.

## Batch Size Guidelines

| Complexity | Batch Size |
|------------|------------|
| Simple tasks (schema, types) | 3-5 tasks |
| Medium tasks (actions, components) | 2-3 tasks |
| Complex tasks (integrations) | 1 task |

## Task Execution Template

For each task:

```markdown
### Task N: [Name]

**Status:** in_progress

**Steps:**
1. [x] Step from plan
2. [x] Step from plan
3. [ ] Verification step

**Verification:**
```bash
npm test -- --grep "task name"
# Result: PASS/FAIL
```

**Status:** completed ✓
```

## Common Mistakes

### Bad: Execute All at Once
```
"I'll complete all 10 tasks and report at the end"
```
Too much risk. Report every 3 tasks.

### Good: Batch and Report
```
Batch 1 (Tasks 1-3): Done, reporting...
[Wait for feedback]
Batch 2 (Tasks 4-6): Done, reporting...
```

### Bad: Continue After Failure
```
Task 3 test failed, but I'll keep going
```
Failures compound. Stop and investigate.

### Good: Stop and Report
```
Task 3 test failed.
Error: "Expected 200, got 401"
Stopping for guidance.
```

### Bad: Deviate from Plan
```
"The plan says X but I think Y is better"
```
Plans exist for a reason.

### Good: Raise Concerns First
```
"Plan says X. I see a potential issue because Z.
Should I proceed as written or adjust?"
```

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| Load | Read plan, identify tasks | Concerns or "ready" |
| Execute | ~3 tasks with verification | Task completion status |
| Report | Present results | "Ready for feedback" |
| Continue | Incorporate feedback, next batch | Progress update |
| Complete | Full verification, options | Commit/PR/Review |

## The Mantra

```
BATCH → VERIFY → REPORT → WAIT → REPEAT
```

Never rush through. Never skip verification. Never continue without feedback.
