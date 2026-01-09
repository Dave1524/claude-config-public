---
name: writing-plans
description: Use when implementing a feature that needs structured breakdown into testable tasks before coding
---

# Writing Plans

## Overview

**Core principle:** Write comprehensive implementation plans assuming the engineer has zero context for the codebase.

Plans break features into small, testable tasks that can be executed by a fresh agent or developer with no prior knowledge of the project.

## When to Use

**Use this pattern when:**
- Feature requires multiple files or components
- Implementation order matters
- You want to hand off execution to subagents
- Complex feature needs TDD breakdown
- Onboarding someone to implement a feature

**Do NOT use when:**
- Simple one-file change
- Bug fix with obvious solution
- Exploratory work without clear goal

## Plan Structure

### File Location

Save plans to: `docs/plans/YYYY-MM-DD-<feature-name>.md`

### Required Header

```markdown
# Feature: <Feature Name>

## Goal
<One sentence describing what this feature does>

## Architecture Overview
<2-3 sentences on how this fits into the codebase>

## Tech Stack
- Framework: <e.g., Next.js 14, App Router>
- Database: <e.g., Supabase/PostgreSQL>
- Key libraries: <e.g., Zod, TanStack Query>
```

### Task Format

Each task follows TDD methodology:

```markdown
## Task 1: <Descriptive Name>

**Files:** `src/path/to/file.ts`, `tests/path/to/test.ts`

### 1.1 Write Failing Test
```typescript
// tests/feature.test.ts
describe('Feature', () => {
  it('should do X when Y', () => {
    // Test implementation
  });
});
```

### 1.2 Verify Test Fails
```bash
npm test -- --grep "should do X"
# Expected: FAIL - "Expected X but got undefined"
```

### 1.3 Implement Minimal Code
```typescript
// src/feature.ts
export function doX(input: Y): Result {
  // Minimal implementation to pass test
}
```

### 1.4 Verify Test Passes
```bash
npm test -- --grep "should do X"
# Expected: PASS
```

### 1.5 Commit
```bash
git add -A && git commit -m "feat(feature): add X functionality"
```
```

## Task Granularity

**Target:** 2-5 minutes per task

| Too Big | Right Size | Too Small |
|---------|------------|-----------|
| "Implement auth system" | "Add login form validation" | "Add semicolon" |
| "Build API endpoints" | "Create POST /users endpoint" | "Import function" |
| "Set up database" | "Add users table migration" | "Add column comment" |

## Core Values

### DRY (Don't Repeat Yourself)
- Reference existing utilities
- Note shared patterns to extract
- Link to similar implementations

### YAGNI (You Aren't Gonna Need It)
- Only implement what's needed NOW
- No "future-proofing" tasks
- No speculative abstractions

### TDD (Test-Driven Development)
- Every task starts with a failing test
- Test describes expected behavior
- Implementation is minimal to pass

### Frequent Commits
- One commit per task
- Descriptive commit messages
- Easy to bisect/revert

## Execution Handoff

After completing the plan, offer execution options:

### Option 1: Subagent-Driven (Current Session)

```markdown
## Ready to Execute

Plan complete with N tasks. Options:

1. **Subagent execution** - I'll dispatch a fresh subagent per task
   - Each task runs with full context from this plan
   - Progress tracked via TodoWrite
   - Results integrated as agents complete

2. **Manual execution** - You execute tasks yourself
   - Follow each task's steps
   - Commit after each task passes
```

### Option 2: Parallel Session

For complex features, recommend separate execution session:

```markdown
Recommend executing in a fresh session:
1. Open new Claude session
2. Reference this plan: `docs/plans/2024-01-15-user-auth.md`
3. Use executing-plans skill for structured execution
```

## Example Plan Snippet

```markdown
# Feature: User Authentication

## Goal
Allow users to sign up, log in, and maintain authenticated sessions.

## Architecture Overview
Uses Supabase Auth with custom profile table. Auth state managed
via middleware, protected routes check session server-side.

## Tech Stack
- Framework: Next.js 14, App Router
- Auth: Supabase Auth
- Validation: Zod

---

## Task 1: Add User Profile Schema

**Files:** `supabase/migrations/001_profiles.sql`, `src/types/user.ts`

### 1.1 Write Failing Test
```typescript
// tests/schema.test.ts
it('profiles table has required columns', async () => {
  const { data } = await supabase.from('profiles').select('id, email, org_id');
  expect(data).toBeDefined();
});
```

### 1.2 Verify Test Fails
```bash
npm test -- schema
# Expected: relation "profiles" does not exist
```

### 1.3 Implement Minimal Code
```sql
-- supabase/migrations/001_profiles.sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  org_id UUID NOT NULL REFERENCES organizations(id)
);
```

### 1.4 Verify Test Passes
```bash
npm test -- schema
# Expected: PASS
```

### 1.5 Commit
```bash
git add -A && git commit -m "feat(auth): add profiles table schema"
```

---

## Task 2: Add Signup Server Action
...
```

## Quick Reference

| Section | Purpose |
|---------|---------|
| Header | Context for anyone reading plan |
| Goal | One sentence success criteria |
| Architecture | How feature fits in codebase |
| Task N | Single testable unit of work |
| Failing Test | Define expected behavior first |
| Verify Fail | Confirm test catches missing impl |
| Implement | Minimal code to pass test |
| Verify Pass | Confirm implementation works |
| Commit | Atomic, revertible checkpoint |

## Common Mistakes

### Bad: Vague Tasks
```
Task 3: Set up the database stuff
```

### Good: Specific Tasks
```
Task 3: Add profiles table with id, email, org_id columns
Files: supabase/migrations/001_profiles.sql
```

### Bad: No Verification Steps
```
### Implement
Add the login form component
```

### Good: Explicit Verification
```
### 3.2 Verify Test Fails
npm test -- login
# Expected: "LoginForm is not defined"

### 3.4 Verify Test Passes
npm test -- login
# Expected: PASS - "renders email and password fields"
```

### Bad: Giant Tasks
```
Task 1: Implement entire authentication system
```

### Good: Granular Tasks
```
Task 1: Add profiles schema
Task 2: Create signup server action
Task 3: Add signup form component
Task 4: Wire signup form to action
Task 5: Add login server action
...
```
