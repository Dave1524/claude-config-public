# Parallel UI Design Workflow

## Overview

This document defines how to use the **frontend-design plugin**, **frontend-design skill**, and **ui-designer subagent** together for maximum efficiency.

## The Three Components

| Component | Type | Purpose | When to Use |
|-----------|------|---------|-------------|
| `frontend-design:frontend-design` | Plugin | Aesthetic guidelines, anti-patterns, design philosophy | Auto-invoked for frontend tasks |
| `frontend-design` skill | Local Skill | Project-specific design context, Sentinel patterns | Reference during implementation |
| `ui-designer` | Subagent | Autonomous component design, spec creation, handoff docs | Complex multi-component work |

## Parallel Usage Model

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PARALLEL UI DESIGN WORKFLOW                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐            │
│  │  PLUGIN     │    │   SKILL     │    │  SUBAGENT   │            │
│  │  (Auto)     │    │  (Context)  │    │ (Executor)  │            │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘            │
│         │                  │                  │                    │
│         ▼                  ▼                  ▼                    │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐            │
│  │ Aesthetic   │    │ Project     │    │ Component   │            │
│  │ Direction   │    │ Constraints │    │ Execution   │            │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘            │
│         │                  │                  │                    │
│         └────────┬─────────┴──────────┬──────┘                    │
│                  ▼                    ▼                            │
│           ┌─────────────┐    ┌─────────────────┐                  │
│           │   Design    │    │  Implementation │                  │
│           │   System    │────│    Code         │                  │
│           └─────────────┘    └─────────────────┘                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Usage Scenarios

### Scenario 1: Single Component (Simple)

**Use:** Plugin + Skill only (no subagent needed)

```markdown
Task: Add a loading spinner to the upload page

1. Plugin auto-invokes for aesthetic guidance
2. Skill provides Tailwind/shadcn context
3. Implement directly
```

### Scenario 2: Component System (Medium)

**Use:** Plugin + Skill + Subagent for spec creation

```markdown
Task: Design a metrics card system for the dashboard

1. Invoke ui-designer subagent:
   "Design a metrics card system with variants for positive/negative trends,
   loading states, and click-through actions. Follow frontend-design skill."

2. Subagent produces:
   - Component specifications
   - State variations
   - Responsive behavior
   - Dark mode variants
   - Accessibility notes

3. Main agent implements from spec
```

### Scenario 3: Full Page Design (Complex)

**Use:** Parallel subagents with coordination

```markdown
Task: Redesign the entire dashboard page

1. Launch parallel ui-designer agents:

   Agent A: "Design header and navigation components"
   Agent B: "Design metrics summary section"
   Agent C: "Design data table with actions"
   Agent D: "Design sidebar with filters"

2. Each agent:
   - References frontend-design skill for project context
   - Uses plugin guidelines for aesthetic decisions
   - Produces independent component specs

3. Coordinator (main agent):
   - Collects all specs
   - Ensures design consistency
   - Implements cohesively
```

## Invocation Patterns

### Invoke Plugin (Automatic)
The plugin auto-triggers for frontend work. No explicit invocation needed.

### Invoke Skill
```markdown
Use the frontend-design skill for guidance on [specific task]
```

Or read directly:
```markdown
Reference: .claude/claude_skills/frontend-design/SKILL.md
```

### Invoke Subagent
```markdown
Launch ui-designer agent to design [component/system/page]
```

Or via Task tool:
```json
{
  "subagent_type": "ui-designer",
  "prompt": "Design [specific request] following the frontend-design skill guidelines",
  "description": "Design [component name]"
}
```

## Parallel Dispatch Template

For complex UI work, dispatch multiple focused agents:

```markdown
## Parallel UI Design Dispatch

### Agent 1: Layout Structure
- Subagent: ui-designer
- Focus: Page layout, grid system, spacing
- Output: Layout specification

### Agent 2: Component Design
- Subagent: ui-designer
- Focus: Individual component specs
- Output: Component specifications

### Agent 3: Interaction Design
- Subagent: ui-designer
- Focus: States, transitions, animations
- Output: Interaction specifications

### Agent 4: Responsive/Dark Mode
- Subagent: ui-designer
- Focus: Breakpoints, dark mode variants
- Output: Responsive specifications
```

## Coordination Rules

### 1. Single Source of Truth
- **Aesthetic direction**: Plugin defines the philosophy
- **Project constraints**: Skill defines the implementation rules
- **Execution specs**: Subagent produces the deliverables

### 2. No Conflicts
If plugin and skill conflict:
- **Skill wins** (project-specific rules override generic guidelines)
- Document the deviation and reason

### 3. Handoff Protocol
Subagent deliverables must include:
- Component specifications (dimensions, colors, typography)
- All state variations
- Responsive breakpoints
- Dark mode variants
- Accessibility requirements
- Implementation notes (Tailwind classes, shadcn components to use)

### 4. Review Gate
Before implementation:
- [ ] Specs align with frontend-design skill
- [ ] No shadcn/ui modifications required
- [ ] Dark mode considered
- [ ] Accessibility validated
- [ ] Performance constraints met

## Example: Dashboard Metrics Cards

### Step 1: Launch UI Designer
```
Launch ui-designer agent to design a metrics card system for the Sentinel dashboard.

Requirements:
- Show SaaS app count, spend, users metrics
- Support positive/negative trend indicators
- Loading skeleton state
- Click-through to detail views
- Follow frontend-design skill guidelines
- Use Tailwind + shadcn/ui
```

### Step 2: Receive Spec
```markdown
## Component: MetricsCard

### Visual Design
- Width: Full (grid responsive)
- Height: Auto (min-h-[120px])
- Background: bg-card (white/dark)
- Border: border border-border rounded-lg
- Shadow: shadow-sm
- Padding: p-6

### States
- Default: As specified
- Hover: ring-1 ring-primary/20, cursor-pointer
- Loading: Skeleton with pulse animation
- Error: Border red, error icon

### Trend Indicator
- Positive: text-green-600, ArrowUp icon
- Negative: text-red-600, ArrowDown icon
- Neutral: text-muted-foreground, Minus icon

### Typography
- Label: text-sm text-muted-foreground font-medium
- Value: text-3xl font-bold tracking-tight
- Trend: text-sm font-medium

### Responsive
- Mobile: Single column, full width
- Tablet: 2 columns
- Desktop: 3-4 columns

### Dark Mode
- Background: bg-card (CSS variable handles)
- Text: Inherited from theme
- Shadows: Reduced opacity

### Accessibility
- Role: article or button (if clickable)
- aria-label: "[Label]: [Value], [Trend]% [direction]"
- Focus: focus-visible:ring-2 ring-primary
```

### Step 3: Implement
Main agent implements from spec, using plugin guidelines for any aesthetic micro-decisions not covered in spec.

## Anti-Patterns

| Anti-Pattern | Correct Approach |
|--------------|------------------|
| Implementing without spec | Get spec from subagent first |
| Ignoring skill constraints | Always reference skill for project rules |
| Sequential agent dispatch | Parallelize independent design tasks |
| Modifying shadcn components | Extend with wrapper components |
| Skipping dark mode | Always design both modes |

## Integration with TDD

Even with parallel UI design:
1. **Subagent produces spec** (design phase)
2. **Write component test** (test-first)
3. **Implement component** (code phase)
4. **Visual verification** (verify phase)

```markdown
## TDD for UI Components

1. ui-designer produces: MetricsCard spec
2. Write test: renders with correct props, handles states
3. Implement: Create MetricsCard.tsx following spec
4. Verify: Visual matches spec, tests pass
```

## Quick Reference

| Task Complexity | Components to Use |
|-----------------|-------------------|
| Tweak existing | Plugin only (auto) |
| New simple component | Plugin + Skill |
| Component system | Plugin + Skill + 1 Subagent |
| Full page/feature | Plugin + Skill + Parallel Subagents |
| Design system updates | Skill + Dedicated Subagent |
