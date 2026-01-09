---
name: dispatching-parallel-agents
description: Use when facing 2+ independent failures or tasks with no shared state or sequential dependencies. Dispatches specialized parallel agents per problem domain.
---

# Dispatching Parallel Agents

## Overview

**Core principle:** Dispatch one specialized agent per independent problem domain. Let them work concurrently.

When facing multiple unrelated failures or tasks, don't solve them sequentially. Dispatch parallel agents with specialized types, each focused on a single domain, and integrate their results.

## When to Use

**Use this pattern when:**
- 3+ test failures with different root causes
- Multiple broken subsystems that don't share state
- Tasks requiring different expertise domains
- Problems that need no cross-context understanding
- Independent fixes that won't conflict

**Do NOT use when:**
- Failures are causally related (fix one → others resolve)
- Agents would modify shared state
- Sequential order matters (A must complete before B)
- Debugging requires cross-file context to understand

## Specialized Agent Types

Match agent type to the problem domain:

| Problem Type | Agent Type | When to Use |
|--------------|------------|-------------|
| Test failures | `debugger-agent` | Investigating why tests fail |
| Implementation bugs | `debugger-agent` | Root cause analysis |
| Missing features | `tester-agent` | Implement with TDD |
| Code quality issues | `reviewer-agent` | Review and fix quality |
| Codebase questions | `Explore` | Find patterns, files, architecture |
| Complex multi-step | `executor-agent` | Execute a sub-plan |

**Never use `general-purpose` when a specialized agent exists.**

## The Pattern

### Step 1: Group by Problem Domain

Analyze failures and group by root cause category:

```
Test Failures:
- test_user_auth.py::test_login_timeout      → Auth/timing (debugger-agent)
- test_user_auth.py::test_session_expired    → Auth/timing (debugger-agent)
- test_events.py::test_webhook_payload       → Event structure (debugger-agent)
- test_events.py::test_event_ordering        → Event structure (debugger-agent)
- test_worker.py::test_job_completion        → Async execution (debugger-agent)
- test_worker.py::test_retry_logic           → Async execution (debugger-agent)
```

**Result:** 3 domains (auth/timing, events, async) → 3 parallel `debugger-agent` instances

### Step 2: Select Appropriate Agent Types

| Domain | Problem | Agent Type |
|--------|---------|------------|
| Auth/timing | Tests timing out | `debugger-agent` |
| Events | Wrong payload structure | `debugger-agent` |
| Async | Job completion issues | `debugger-agent` |

For mixed problem types:

| Domain | Problem | Agent Type |
|--------|---------|------------|
| Auth | Missing login feature | `tester-agent` |
| Events | Investigate event flow | `Explore` |
| Worker | Fix retry logic bug | `debugger-agent` |

### Step 3: Create Focused Agent Tasks

Each task must be:
- **Focused** - Single domain, clear boundary
- **Self-contained** - All context included
- **Typed correctly** - Use specialized agent
- **Specific about output** - What to return

### Step 4: Dispatch Concurrently

Use the Task tool with multiple parallel invocations in a **single message**:

```xml
<!-- All three Task calls in ONE response block -->
<invoke name="Task">
  <parameter name="description">Debug auth timing issues</parameter>
  <parameter name="prompt">Debug timing issues in test_user_auth.py.

    Failing tests:
    - test_login_timeout: "Connection timeout after 5s"
    - test_session_expired: "Session check hangs"

    Files: src/auth/session.py, tests/test_user_auth.py

    Follow systematic debugging:
    1. UNDERSTAND - What's the actual vs expected behavior?
    2. COMPARE - What works vs what doesn't?
    3. HYPOTHESIZE - What's the likely root cause?
    4. FIX ONCE - Apply single targeted fix

    Return: Root cause, files modified, test results</parameter>
  <parameter name="subagent_type">debugger-agent</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Debug event structure</parameter>
  <parameter name="prompt">Debug event payload structure in test_events.py.

    Failing tests:
    - test_webhook_payload: expects {type, data} but gets {event, payload}
    - test_event_ordering: events arrive out of order

    Files: src/events/webhook.py, tests/test_events.py

    Follow systematic debugging:
    1. UNDERSTAND - What's the actual vs expected behavior?
    2. COMPARE - What works vs what doesn't?
    3. HYPOTHESIZE - What's the likely root cause?
    4. FIX ONCE - Apply single targeted fix

    Return: Root cause, files modified, test results</parameter>
  <parameter name="subagent_type">debugger-agent</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Debug async execution</parameter>
  <parameter name="prompt">Debug async worker issues in test_worker.py.

    Failing tests:
    - test_job_completion: job hangs, never completes
    - test_retry_logic: fails on 3rd retry attempt

    Files: src/worker/executor.py, tests/test_worker.py

    Follow systematic debugging:
    1. UNDERSTAND - What's the actual vs expected behavior?
    2. COMPARE - What works vs what doesn't?
    3. HYPOTHESIZE - What's the likely root cause?
    4. FIX ONCE - Apply single targeted fix

    Return: Root cause, files modified, test results</parameter>
  <parameter name="subagent_type">debugger-agent</parameter>
</invoke>
```

### Step 5: Review and Integrate

When all agents complete:
1. Review each agent's summary
2. Check for unexpected conflicts
3. Run full test suite
4. Commit changes together or separately

## Mixed Agent Type Example

When problems require different expertise:

```xml
<!-- Implementation + Exploration + Debugging in parallel -->
<invoke name="Task">
  <parameter name="description">Implement user preferences</parameter>
  <parameter name="prompt">Implement user preferences feature.

    Goal: Add preferences table and CRUD operations
    Files: migrations/preferences.sql, src/actions/preferences.ts
    Tests: preferences table exists, CRUD operations work

    Follow TDD: Write test first, see it fail, implement, see it pass.

    Return: Files modified, test results</parameter>
  <parameter name="subagent_type">tester-agent</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Explore notification patterns</parameter>
  <parameter name="prompt">Explore the codebase to understand notification patterns.

    Find:
    - How are notifications currently sent?
    - What notification channels exist?
    - Where is notification logic located?

    Return: Summary of patterns, key files, recommendations</parameter>
  <parameter name="subagent_type">Explore</parameter>
</invoke>

<invoke name="Task">
  <parameter name="description">Debug email sending</parameter>
  <parameter name="prompt">Debug email sending failures.

    Issue: Emails not being delivered in production
    Error: "SMTP connection refused" in logs

    Files: src/services/email.ts, src/config/smtp.ts

    Follow systematic debugging to find root cause.

    Return: Root cause, fix applied, verification</parameter>
  <parameter name="subagent_type">debugger-agent</parameter>
</invoke>
```

## Agent Type Selection Matrix

| Scenario | Agent Type | Why |
|----------|------------|-----|
| Tests failing, need root cause | `debugger-agent` | Systematic debugging methodology |
| Need to implement new feature | `tester-agent` | Enforces TDD (Red-Green-Refactor) |
| Code quality/review needed | `reviewer-agent` | Spec compliance + quality checks |
| Find files/patterns in codebase | `Explore` | Fast, focused exploration |
| Execute a detailed sub-plan | `executor-agent` | Plan execution with checkpoints |
| Final verification before done | `finisher-agent` | Integration testing, cleanup |

## Agent Prompt Structure

| Element | Purpose | Example |
|---------|---------|---------|
| Domain scope | What to fix/do | "Debug timing issues in auth tests" |
| Error details | Specific failures | "test_login_timeout fails with 'Connection timeout'" |
| Files | Boundaries | "Files: src/auth/session.py, tests/test_user_auth.py" |
| Methodology | How to approach | "Follow systematic debugging" or "Follow TDD" |
| Output spec | What to return | "Return: root cause, files modified, test results" |

## Common Mistakes

### Bad: Wrong Agent Type
```xml
<parameter name="subagent_type">general-purpose</parameter>
```
Misses specialized methodology (TDD, systematic debugging, etc.)

### Good: Matched Agent Type
```xml
<!-- For test failures -->
<parameter name="subagent_type">debugger-agent</parameter>

<!-- For new features -->
<parameter name="subagent_type">tester-agent</parameter>

<!-- For exploration -->
<parameter name="subagent_type">Explore</parameter>
```

### Bad: Overly Broad Task
```
"Fix all the failing tests"
```
Agent lacks focus, may conflict with others.

### Good: Focused Task
```
"Debug timing issues in auth tests. Errors: test_login_timeout
fails with 'Connection timeout after 5s'. Files: src/auth/session.py,
tests/test_user_auth.py"
```

### Bad: Missing Context
```
"Fix the webhook tests"
```
Agent must waste time discovering what's wrong.

### Good: Complete Context
```
"Debug event payload structure. test_webhook_payload expects
{type, data} but receives {event, payload}. See webhook.py:45"
```

### Bad: Vague Output
```
"Let me know what you find"
```
Hard to integrate results.

### Good: Specific Output
```
"Return: root cause, files modified, specific changes made, test results"
```

## Real Example

**Scenario:** 6 test failures across 3 files after refactor

**Analysis:**
- `test_auth.py` (2 failures) → timing/session issues → `debugger-agent`
- `test_events.py` (2 failures) → event structure mismatch → `debugger-agent`
- `test_worker.py` (2 failures) → async execution bugs → `debugger-agent`

**Action:** Dispatched 3 `debugger-agent` instances in parallel

**Result:**
- All 3 agents completed concurrently
- Zero conflicts (no shared state)
- Full test suite passed
- Total time: ~2 minutes (vs ~6 minutes sequential)

## Quick Reference

| Parallel | Sequential |
|----------|------------|
| Independent root causes | Related root causes |
| No shared state | Shared state/files |
| Different domains | Same domain |
| Clear boundaries | Unclear boundaries |

| Problem Type | Agent Type |
|--------------|------------|
| Test failures | `debugger-agent` |
| New features | `tester-agent` |
| Code review | `reviewer-agent` |
| Find patterns | `Explore` |
| Execute plan | `executor-agent` |
| Final check | `finisher-agent` |

## Red Flags - Go Sequential Instead

- "This might affect the other fix"
- "Need to see what the first agent finds"
- "These tests share setup/fixtures"
- "One failure might cause the others"

## The Mantra

```
GROUP → TYPE → DISPATCH → INTEGRATE
```

One specialized agent per domain. Parallel when independent. Integrate results.
