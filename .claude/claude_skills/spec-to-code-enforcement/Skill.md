---
name: Spec-to-Code Enforcement
description: Validates code against markdown specs. Detects missing implementations, over-implementations, and constraint violations. Use for spec compliance audits.
---

# Claude Code Skill: Spec-to-Code Enforcement

## Purpose
Enforce strict alignment between a markdown specification and its corresponding code implementation.

This skill treats the specification as a **contract**, not a suggestion.

The goal is to detect:
- Missing implementations
- Over-implementation (hallucinated features)
- Structural drift
- Violations of explicit constraints

This skill MUST prioritize correctness and completeness over creativity.

---

## When to Use This Skill
Invoke this skill when:
- Writing new code from an existing `.md` spec
- Reviewing generated code for correctness
- Auditing changes after refactors
- Preparing code for merge or demo

This skill is NOT for:
- Designing new features
- Improving code quality beyond spec
- Refactoring unless explicitly required by spec

---

## Inputs

### Required Inputs

1. **Specification**
   - Type: Markdown document
   - Description: The authoritative functional and structural definition
   - Example:
     - `07_insights_generation.md.v2.md`

2. **Code Target**
   - Type: File or directory
   - Description: The implementation to be validated
   - Example:
     - `src/app/actions/insights.ts`
     - `src/components/insights-list.tsx`

---

## Validation Rules (Hard Constraints)

Claude MUST follow these rules exactly:

### Rule 1: Spec Supremacy
- The specification is the single source of truth.
- If code contradicts the spec, the code is wrong.
- If something is unclear, flag it — do NOT guess.

### Rule 2: No Assumptions
- Do NOT infer features that are not explicitly described.
- Do NOT "fill in gaps" with best practices unless mandated.
- Ambiguity must be reported as ambiguity.

### Rule 3: Exhaustive Coverage
- Every required element in the spec must be checked.
- Every implemented element must be justified by the spec.

---

## What to Extract From the Spec

Claude MUST explicitly extract and list:

- Declared responsibilities
- Required inputs and outputs
- Functions, classes, or modules
- Required fields and data structures
- Explicit constraints (e.g. "must not", "should only", "non-goals")
- Error handling requirements
- Integration points (APIs, DBs, services)

---

## What to Extract From the Code

Claude MUST identify:

- Implemented functions, classes, and modules
- Inputs and outputs
- Side effects
- External dependencies
- Implicit behaviors not mentioned in the spec

---

## Output Format (MANDATORY)

Claude MUST return the result in the following structure:

### 1. Compliance Summary
- Status: `PASS` | `PARTIAL` | `FAIL`
- One-paragraph explanation

### 2. Missing Implementations
List all spec-defined elements that are:
- Missing
- Partially implemented
- Stubbed without logic

Format:
- Spec Reference
- Expected Behavior
- Current State

### 3. Overreach / Hallucinations
List all code elements that:
- Are not defined in the spec
- Exceed defined responsibilities

Format:
- Code Element
- Why It Is Not Allowed
- Risk Introduced

### 4. Violations of Constraints
List all violations of:
- Non-goals
- Explicit exclusions
- Architectural constraints

### 5. Ambiguities & Spec Gaps
ONLY list ambiguities explicitly present in the spec.
Do NOT propose solutions.

### 6. Required Actions
A concrete, ordered list of changes required to reach full compliance.
No optional suggestions.

---

## Tone & Behavior Constraints

Claude MUST:
- Be strict
- Be precise
- Be unemotional
- Avoid praise
- Avoid speculative language

Claude MUST NOT:
- Say "looks good"
- Suggest improvements beyond the spec
- Rewrite the spec
- Assume future roadmap items

---

## Example Invocation

> Validate `src/app/actions/insights.ts` against `07_insights_generation.md.v2.md` using the spec_to_code_enforcement skill.

---

## Success Criteria
This skill is successful if:
- A human reviewer can trust the output without re-reading the entire spec
- No undocumented behavior passes unnoticed
- No spec requirement is silently skipped
