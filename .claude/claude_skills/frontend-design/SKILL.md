# Frontend Design Skill

## Metadata

| Field | Value |
|-------|-------|
| Name | frontend-design |
| Trigger | When creating UI components, pages, dashboards, landing pages, or any frontend work |
| Plugin | `frontend-design:frontend-design` (claude-plugins-official) |
| Subagent | `ui-designer` (for autonomous component design work) |
| Coordination | See `parallel-ui-workflow.md` for multi-component scenarios |

## Purpose

Create distinctive, production-grade frontend interfaces with high design quality. This skill guides creation of frontends that avoid generic "AI slop" aesthetics by emphasizing intentional design choices and meticulous attention to detail.

## Parallel UI Design System

This skill works with two complementary components for maximum flexibility:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    UI DESIGN COMPONENT HIERARCHY                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              frontend-design:frontend-design                 │   │
│  │                      (PLUGIN)                                │   │
│  │  Provides: Aesthetic philosophy, anti-patterns, principles   │   │
│  │  Invocation: Auto-triggers for frontend work                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  frontend-design (SKILL)                     │   │
│  │                       (THIS FILE)                            │   │
│  │  Provides: Project-specific context, Sentinel patterns       │   │
│  │  Invocation: /frontend-design or reference directly          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                   ui-designer (SUBAGENT)                     │   │
│  │                  ~/.claude/agents/ui-designer.md             │   │
│  │  Provides: Autonomous design execution, component specs      │   │
│  │  Invocation: Task tool with subagent_type="ui-designer"      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### When to Use Each

| Scenario | Use |
|----------|-----|
| Simple tweak/fix | Plugin auto-invokes |
| New component (clear requirements) | Plugin + This Skill |
| Component system design | Plugin + Skill + ui-designer subagent |
| Full page redesign | Parallel ui-designer subagents |
| Design system updates | ui-designer subagent + This Skill |

### Parallel Subagent Dispatch

For complex UI work, dispatch multiple ui-designer agents in parallel:

```markdown
## Example: Dashboard Redesign

### Parallel Dispatch (single message, multiple Task calls)

Agent 1: "Design header and navigation" → ui-designer
Agent 2: "Design metrics cards section" → ui-designer
Agent 3: "Design data table component" → ui-designer
Agent 4: "Design sidebar filters" → ui-designer

### Each agent receives:
- frontend-design skill guidelines (this file)
- Plugin aesthetic principles (auto)
- Specific component focus
```

See `parallel-ui-workflow.md` for detailed coordination patterns.

## Invocation

### Plugin (Automatic)
The plugin auto-triggers for frontend work. No explicit invocation needed.

### Skill (This File)
```
/frontend-design
```
Or reference directly:
```
Use the frontend-design skill to create a dashboard for SaaS metrics
```

### Subagent (For Complex Work)
```
Launch ui-designer agent to design [component/system/page]
```
Via Task tool:
```json
{
  "subagent_type": "ui-designer",
  "prompt": "Design [component] following frontend-design skill",
  "description": "Design [name]"
}
```

## Design Thinking Framework

Before coding any frontend:

### 1. Understand Context
- What problem does this solve?
- Who are the users?
- What are the technical constraints?
- What is the existing design system (if any)?

### 2. Commit to Aesthetic Direction
Choose a bold conceptual approach:

| Direction | Characteristics |
|-----------|----------------|
| Brutally Minimal | Maximum whitespace, essential elements only |
| Maximalist | Rich detail, layered complexity |
| Retro-Futuristic | Nostalgic tech meets modern polish |
| Luxury/Refined | Premium materials, subtle animations |
| Playful | Whimsical, delightful interactions |
| Editorial | Magazine-inspired typography and layout |
| Brutalist | Raw, honest, unconventional |
| Art Deco | Geometric patterns, metallic accents |
| Soft/Pastel | Gentle colors, rounded forms |
| Industrial | Exposed structure, utilitarian |

### 3. Execute with Intentionality
**"Intentionality, not intensity"** - Every design choice should have a reason.

## Frontend Aesthetics Guidelines

### Typography
- Choose fonts that are beautiful, unique, and interesting
- **Avoid**: Arial, Inter, system defaults
- **Prefer**: Distinctive, characterful fonts paired strategically
- Use font scale with clear hierarchy
- Consider variable fonts for dynamic weight

### Color & Theme
- Commit to cohesive aesthetics using CSS variables
- Use dominant colors with sharp accents
- Consider light/dark mode from the start
- Build a semantic color system (not just `blue-500`)

### Motion & Animation
- Prioritize CSS-only solutions (transforms, transitions)
- Use high-impact orchestrated moments:
  - Staggered reveals
  - Scroll-triggered effects
  - Micro-interactions on user actions
- Performance matters: prefer `transform` and `opacity`

### Spatial Composition
- Employ unexpected layouts
- Use asymmetry intentionally
- Consider overlap and layering
- Diagonal flows create energy
- Grid systems enable creative constraints

### Visual Details
- Build atmosphere through:
  - Textures and gradients
  - Patterns (geometric, organic)
  - Contextual effects (shadows, glows)
  - Border treatments
  - Background depth

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad |
|--------------|--------------|
| Generic AI aesthetics | Indistinguishable from every other AI output |
| Inter everywhere | Overused, lacks character |
| Purple gradients | Clichéd "tech" look |
| Card grids with rounded corners | Default, thoughtless layout |
| Generic icons | No personality or context |
| Predictable layouts | Boring, forgettable |
| Context-less design | Doesn't serve the actual use case |

## Project Sentinel Context

When applying this skill to Project Sentinel:

### Existing Design System
- Using Tailwind CSS with shadcn/ui components
- Dark mode support via `next-themes`
- Primary brand color: defined in `tailwind.config.ts`

### Component Locations
- UI primitives: `src/components/ui/`
- Feature components: `src/components/`
- Page layouts: `src/app/(dashboard)/`

### Key Screens
- Dashboard overview with SaaS metrics
- Invoice upload interface
- Discovery results table
- Insights and recommendations
- Settings and organization management

### Recommended Aesthetic for Sentinel
Given the SaaS governance context:
- **Direction**: Luxury/Refined meets Editorial
- **Rationale**: Professional B2B audience expects polish; data-heavy content benefits from editorial typography
- **Key elements**:
  - Clear data visualization hierarchy
  - Generous whitespace for scannability
  - Subtle animations on state changes
  - Premium feel without being flashy

## Implementation Philosophy

Match code complexity to aesthetic vision:
- **Maximalist designs** require elaborate effects, complex animations, rich detail
- **Minimalist designs** demand precision, restraint, perfect spacing

## Integration with TDD

Even frontend code follows TDD principles:
1. Write test for component behavior
2. Implement visual design
3. Verify accessibility
4. Test responsive behavior

## Integration with ui-designer Subagent

The `ui-designer` subagent (located at `~/.claude/agents/ui-designer.md`) is designed to work seamlessly with this skill.

### Subagent Capabilities

| Capability | Description |
|------------|-------------|
| Component Specs | Full visual specifications with dimensions, colors, states |
| Design Systems | Design token creation, component library maintenance |
| Accessibility | WCAG 2.1 AA compliance, focus management, keyboard nav |
| Responsive Design | Breakpoint handling, mobile-first approach |
| Dark Mode | Complete dark mode variants with proper contrast |
| Motion Design | Animation specs with performance considerations |
| Handoff Docs | Implementation guidelines, Tailwind classes, notes |

### Invoking the Subagent

```markdown
Launch ui-designer agent to design a [component/feature] for Project Sentinel.

Requirements:
- [Specific requirements]
- Follow frontend-design skill guidelines
- Use Tailwind + shadcn/ui
- Include dark mode variants
- WCAG 2.1 AA accessibility
```

### Parallel Dispatch for Complex Work

For multi-component features, dispatch parallel ui-designer agents:

```markdown
## Parallel UI Design

Task: Redesign dashboard page

### Agent Dispatch (single message)
1. ui-designer: "Design header/navigation"
2. ui-designer: "Design metrics cards"
3. ui-designer: "Design data tables"
4. ui-designer: "Design filter sidebar"

### Coordination
- Each agent produces independent specs
- Main agent collects and ensures consistency
- Implement from combined specifications
```

### Subagent Output Format

The ui-designer subagent produces structured deliverables:

```markdown
## Component: [Name]

### Visual Design
- Dimensions, colors, typography, spacing, borders

### States
- Default, hover, active, focus, disabled, loading, error

### Responsive
- Mobile, tablet, desktop breakpoints

### Dark Mode
- All color/shadow adaptations

### Accessibility
- ARIA roles, labels, keyboard interactions, contrast ratios

### Implementation Notes
- Tailwind classes to use
- shadcn components to extend
- Animation approach
```

## Workflow Integration

### With TDD Skills

```
1. ui-designer produces spec
2. test-driven-development: Write failing component test
3. frontend-design skill: Guide implementation
4. verification-before-completion: Verify visual + functional
```

### With Planning Skills

```
1. writing-plans: Break UI feature into tasks
2. Each task: ui-designer spec → TDD implementation
3. executing-plans: Batch component implementation
4. reviewer-agent: Design consistency check
```

### With Parallel Agents

```
dispatching-parallel-agents:
  - ui-designer: Component A spec
  - ui-designer: Component B spec
  - ui-designer: Component C spec

→ Collect specs → Implement in sequence
```

## Quick Reference Card

| Need | Use | Invocation |
|------|-----|------------|
| Aesthetic guidance | Plugin | Auto |
| Project context | This Skill | `/frontend-design` |
| Component spec | ui-designer | Task tool |
| Multi-component | Parallel ui-designer | Multiple Task calls |
| Full page | Parallel + Coordination | See parallel-ui-workflow.md |

## Related Files

| File | Purpose |
|------|---------|
| `parallel-ui-workflow.md` | Detailed parallel coordination patterns |
| `~/.claude/agents/ui-designer.md` | Full subagent definition |
| `src/components/ui/` | shadcn/ui primitives |
| `tailwind.config.ts` | Design tokens configuration |
| `src/app/globals.css` | CSS variables and custom styles |

## Resources

- [Frontend Aesthetics Cookbook](https://github.com/anthropics/claude-cookbooks/blob/main/coding/prompting_for_frontend_aesthetics.ipynb)
- [VoltAgent UI Designer](https://github.com/VoltAgent/awesome-claude-code-subagents/blob/main/categories/01-core-development/ui-designer.md)
- shadcn/ui documentation
- Tailwind CSS documentation
