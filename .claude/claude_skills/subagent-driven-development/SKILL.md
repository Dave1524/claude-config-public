---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session. Dispatches specialized subagents with parallel execution for independent tasks and two-stage parallel review.
---

# Subagent-Driven Development

## Overview

**Core principle:** Specialized agents + parallel execution + parallel review = high quality, fast iteration.

Execute implementation plans by dispatching specialized subagents, running independent tasks in parallel, and performing spec compliance and code quality reviews concurrently.

## When to Use

**Use this skill when:**
- You have a finalized implementation plan
- Tasks are mostly independent
- Staying in the current session
- Want quality gates between tasks

**Do NOT use when:**
- Tasks have tight dependencies (use sequential execution)
- Exploratory work without clear requirements
- Simple single-task work (overkill)

## Specialized Agent Types

Use the right agent for each job:

| Task Type | Agent Type | Why |
|-----------|------------|-----|
| Implementation | `tester-agent` | Enforces strict TDD (Red-Green-Refactor) |
| Spec Review | `reviewer-agent` | Specialized for spec compliance checks |
| Quality Review | `reviewer-agent` | Specialized for code quality reviews |
| Final Integration | `finisher-agent` | Final verification before completion |
| Debugging Failures | `debugger-agent` | Root cause investigation |
| Codebase Exploration | `Explore` | Fast file/code search |

**Never use `general-purpose` when a specialized agent exists.**

## The Enhanced Workflow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ENHANCED SUBAGENT-DRIVEN DEVELOPMENT                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. ANALYZE PLAN                                                        │
│     └── Identify independent vs dependent tasks                         │
│     └── Group independent tasks for parallel dispatch                   │
│                                                                         │
│  2. DISPATCH (specialized agents)                                       │
│     ├── Independent tasks → Parallel tester-agents                      │
│     └── Dependent tasks → Sequential tester-agents                      │
│                                                                         │
│  3. PARALLEL REVIEW (single message, both reviewers)                    │
│     └── reviewer-agent × 2 dispatched together:                         │
│         ├── Spec compliance check                                       │
│         └── Code quality check                                          │
│                                                                         │
│  4. FIX IF NEEDED                                                       │
│     └── debugger-agent for root cause analysis                          │
│     └── Re-review after fix                                             │
│                                                                         │
│  5. FINAL VERIFICATION                                                  │
│     └── finisher-agent for integration review                           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Step-by-Step Guide

### Step 1: Analyze Plan for Parallelism

Before executing, classify tasks:

```markdown
## Task Analysis

Independent (can run in parallel):
- Task 1: Add user schema (files: migrations/users.sql)
- Task 2: Add products schema (files: migrations/products.sql)
- Task 3: Add orders schema (files: migrations/orders.sql)

Dependent (must run sequentially):
- Task 4: Add order-items schema (depends on Task 2, 3)
- Task 5: Create order service (depends on Task 3, 4)

Parallel Batches:
- Batch 1: Tasks 1, 2, 3 (parallel)
- Batch 2: Task 4 (sequential, after Batch 1)
- Batch 3: Task 5 (sequential, after Task 4)
```

**Independence criteria:**
- Different files
- No shared state
- No data dependencies
- Can be verified separately

### Step 2: Dispatch Implementers

#### For Independent Tasks: Parallel Dispatch

Dispatch multiple `tester-agent` instances in a **single message**:

```xml
<!-- All Task calls in ONE response block -->
<invoke name="Task">
  <parameter name="description">Implement user schema</parameter>
  <parameter name="prompt">Implement user schema migration.
    Goal: Create users table with id, email, created_at
    Files: supabase/migrations/001_users.sql
    Test: Table exists with correct columns
    Constraints: No foreign keys in this task
    Follow TDD: Write test first, see it fail, implement, see it pass.</parameter>
  <parameter name="subagent_type">tester-agent</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Implement products schema</parameter>
  <parameter name="prompt">Implement products schema migration.
    Goal: Create products table with id, name, price
    Files: supabase/migrations/002_products.sql
    Test: Table exists with correct columns
    Constraints: No foreign keys in this task
    Follow TDD: Write test first, see it fail, implement, see it pass.</parameter>
  <parameter name="subagent_type">tester-agent</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Implement orders schema</parameter>
  <parameter name="prompt">Implement orders schema migration.
    Goal: Create orders table with id, user_id, status
    Files: supabase/migrations/003_orders.sql
    Test: Table exists with correct columns
    Constraints: No foreign keys in this task
    Follow TDD: Write test first, see it fail, implement, see it pass.</parameter>
  <parameter name="subagent_type">tester-agent</parameter>
</invoke>
```

#### For Dependent Tasks: Sequential Dispatch

```xml
<invoke name="Task">
  <parameter name="description">Implement order-items schema</parameter>
  <parameter name="prompt">Implement order-items schema migration.
    Goal: Create order_items table with FK to orders and products
    Files: supabase/migrations/004_order_items.sql
    Prerequisites: orders and products tables exist
    Test: Table exists with correct FKs
    Follow TDD: Write test first, see it fail, implement, see it pass.</parameter>
  <parameter name="subagent_type">tester-agent</parameter>
</invoke>
```

### Step 3: Parallel Review

After implementation, dispatch **both reviewers in a single message**:

```xml
<!-- Both reviews in ONE response block -->
<invoke name="Task">
  <parameter name="description">Spec compliance review</parameter>
  <parameter name="prompt">Review spec compliance for [task].

    Spec requirements:
    1. [ ] Requirement 1
    2. [ ] Requirement 2
    3. [ ] Requirement 3

    Files to review: [list files]

    Check:
    - All requirements implemented
    - No over-implementation (features not in spec)
    - Constraints respected

    Return: PASS or list of gaps with file:line references.</parameter>
  <parameter name="subagent_type">reviewer-agent</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Code quality review</parameter>
  <parameter name="prompt">Review code quality for [task].

    Files: [list files]

    Check:
    - [ ] No TypeScript `any` types
    - [ ] Proper error handling
    - [ ] No hardcoded secrets
    - [ ] Input validation at boundaries
    - [ ] Meaningful tests
    - [ ] Clear naming

    Return: PASS or list of issues with specific fixes.</parameter>
  <parameter name="subagent_type">reviewer-agent</parameter>
</invoke>
```

**Why parallel reviews?**
- Spec review checks: "Does it match requirements?"
- Quality review checks: "Is it well-written?"
- No dependency between them
- Saves ~50% review time

### Step 4: Handle Failures with Debugger

If reviews fail, use `debugger-agent` for root cause:

```xml
<invoke name="Task">
  <parameter name="description">Debug review failures</parameter>
  <parameter name="prompt">Debug the following review failures.

    Spec Review Issues:
    - Missing requirement X in file.ts:42

    Quality Review Issues:
    - Uses `any` type in handler.ts:15
    - Missing error handling in service.ts:88

    Investigate root cause, fix issues, and verify fixes.
    Follow systematic debugging: UNDERSTAND → COMPARE → HYPOTHESIZE → FIX ONCE</parameter>
  <parameter name="subagent_type">debugger-agent</parameter>
</invoke>
```

**After fix:** Re-run parallel reviews to verify.

### Step 5: Final Verification

After all tasks complete, use `finisher-agent`:

```xml
<invoke name="Task">
  <parameter name="description">Final integration review</parameter>
  <parameter name="prompt">Perform final integration verification.

    All implemented files: [list all files]

    Verify:
    - All tests pass together (run full suite)
    - Components integrate correctly
    - No conflicting changes
    - No regressions
    - Ready for merge/PR

    Return: PASS with summary, or FAIL with integration issues.</parameter>
  <parameter name="subagent_type">finisher-agent</parameter>
</invoke>
```

## Advanced: Background Context Preparation

While reviewing Task N, prepare context for Task N+1 in background:

```xml
<!-- Current review -->
<invoke name="Task">
  <parameter name="description">Review Task 3</parameter>
  <parameter name="prompt">Review spec compliance for Task 3...</parameter>
  <parameter name="subagent_type">reviewer-agent</parameter>
</invoke>

<!-- Background: Explore context for next task -->
<invoke name="Task">
  <parameter name="description">Prepare Task 4 context</parameter>
  <parameter name="prompt">Explore codebase to gather context for Task 4.
    Find: existing patterns for [feature type]
    Files: related implementations
    Return: Summary of patterns and relevant files.</parameter>
  <parameter name="subagent_type">Explore</parameter>
  <parameter name="run_in_background">true</parameter>
</invoke>
```

Use `TaskOutput` to retrieve background results when ready.

## Parallelism Decision Matrix

| Scenario | Approach | Agent Type |
|----------|----------|------------|
| 2+ tasks, different files, no deps | Parallel dispatch | `tester-agent` × N |
| Tasks share files | Sequential dispatch | `tester-agent` |
| Task B needs Task A's output | Sequential dispatch | `tester-agent` |
| Spec + Quality review | Parallel dispatch | `reviewer-agent` × 2 |
| Review failures | Debug first | `debugger-agent` |
| All tasks done | Final check | `finisher-agent` |

## Prompt Templates

### Implementer Prompt (for tester-agent)
```
Implement [task name].

Goal: [What to achieve]

Files to create/modify:
- [file1]: [purpose]
- [file2]: [purpose]

Requirements:
1. [Requirement 1]
2. [Requirement 2]

Tests should verify:
- [Test case 1]
- [Test case 2]

Constraints:
- Do NOT [constraint]
- Do NOT [constraint]

Follow TDD: Write test first, see it fail, implement, see it pass.

Return: Files modified, test results, any concerns.
```

### Spec Review Prompt (for reviewer-agent)
```
Review spec compliance for [task].

Requirements from spec:
1. [ ] Requirement 1
2. [ ] Requirement 2

Files implemented: [list]

Verify:
- Each requirement is implemented
- No extra features added
- Constraints respected

Return: PASS or specific gaps with file:line references.
```

### Quality Review Prompt (for reviewer-agent)
```
Review code quality for [task].

Files: [list]

Check for:
- [ ] No `any` types
- [ ] Proper error handling
- [ ] No hardcoded secrets
- [ ] Input validation
- [ ] Meaningful tests
- [ ] Clear naming

Return: PASS or specific issues with fixes.
```

### Debug Prompt (for debugger-agent)
```
Debug the following issues in [task].

Issues found:
1. [Issue 1 with file:line]
2. [Issue 2 with file:line]

Follow systematic debugging:
1. UNDERSTAND - What's the actual vs expected behavior?
2. COMPARE - What works vs what doesn't?
3. HYPOTHESIZE - What's the likely root cause?
4. FIX ONCE - Apply single targeted fix

Return: Root cause, fix applied, verification results.
```

### Final Review Prompt (for finisher-agent)
```
Perform final integration verification.

All files: [list all modified files]

Tasks completed:
1. [Task 1]
2. [Task 2]

Verify:
- Run full test suite
- Check components integrate
- No conflicting changes
- No regressions

Return: PASS with summary, or integration issues to resolve.
```

## Critical Constraints

**Never:**
- Use `general-purpose` when specialized agent exists
- Skip either review stage
- Proceed with unresolved issues
- Parallelize tasks that share files
- Let subagent read plan file directly (inject context)

**Always:**
- Analyze plan for parallelism opportunities first
- Use parallel dispatch for independent tasks
- Run both reviews in parallel
- Use `debugger-agent` for failures
- Use `finisher-agent` for final verification
- Answer subagent questions completely
- Re-review after any fix

## Common Mistakes

### Bad: Sequential Independent Tasks
```
Task 1 (done) → Task 2 (done) → Task 3 (done)
```
Wastes time when tasks are independent.

### Good: Parallel Independent Tasks
```
[Task 1 ║ Task 2 ║ Task 3] → all done
```

### Bad: Sequential Reviews
```
Implementation → Spec Review (wait) → Quality Review (wait)
```

### Good: Parallel Reviews
```
Implementation → [Spec Review ║ Quality Review] → Continue
```

### Bad: Wrong Agent Type
```
subagent_type: general-purpose  (for everything)
```

### Good: Specialized Agents
```
Implementation:  subagent_type: tester-agent
Reviews:         subagent_type: reviewer-agent
Debugging:       subagent_type: debugger-agent
Final check:     subagent_type: finisher-agent
```

### Bad: Fix Without Investigation
```
Review failed → Guess fix → Hope it works
```

### Good: Debug First
```
Review failed → debugger-agent → Root cause → Targeted fix
```

## Quick Reference

| Phase | Agent Type | Parallel? |
|-------|------------|-----------|
| Implement independent tasks | `tester-agent` | Yes |
| Implement dependent tasks | `tester-agent` | No |
| Spec + Quality review | `reviewer-agent` × 2 | Yes |
| Debug failures | `debugger-agent` | No |
| Final integration | `finisher-agent` | No |
| Explore context | `Explore` | Background |

## The Mantra

```
ANALYZE → PARALLELIZE → IMPLEMENT → PARALLEL REVIEW → NEXT
```

Specialized agents. Parallel when possible. No shortcuts.
