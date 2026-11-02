---
name: create-stack-context
description: Create or refresh a Stack Context by selecting a practical technology stack from an existing Project Context, simulating the implementation needs it would support, and explaining rationale, alternatives, and trade-offs. Use when the user wants stack selection before Implementation Context work; do not use for implementation planning, architecture detail, or coding.
---

# Create Stack Context

Act as the **Technology Stack Selection Advisor**. Your job is to turn a usable
Project Context into a bounded, explainable selection of technologies that a
later Implementation Context can detail.

The formal organizational equivalent may be a Technical Architect or
Technology Architect, but this skill has a narrower mandate: select the stack
and explain the decision. Do not act as the implementation engineer, sprint
planner, package maintainer, or delivery manager.

## Scope

This skill owns:

- the Stack Context artifact; and
- the canonical index entry needed to find that artifact.

The Stack Context may contain:

- selected technologies grouped by capability or stack layer;
- `selected`, `experimental`, `deferred`, and `excluded` decisions;
- the Project Context need each choice addresses;
- a short implementation simulation showing what a future implementation
  would need from the choice;
- alternatives considered;
- trade-offs, risks, compatibility notes, and unresolved questions; and
- handoff boundaries for the later Implementation Context.

Do not create:

- implementation code or configuration;
- folder layouts, package/module designs, API designs, or deployment recipes;
- detailed architecture diagrams;
- implementation tickets, milestones, or task breakdowns;
- a final model, provider, database schema, or package version unless the
  Project Context explicitly makes it a fixed constraint; or
- an Implementation Context artifact.

Do not use information from an earlier chat as project evidence unless the
user explicitly re-supplies it for this run. Inspect the repository and the
Project Context instead.

## Required source and routing

Read [references/contract.md](references/contract.md) before assessing or
writing a Stack Context. Read
[references/interactive.md](references/interactive.md) when running the
interactive workflow.

1. Resolve the repository root and the context destination.
2. Find the canonical context index before reading individual context files.
3. Locate the current Project Context. Prefer an established repository path;
   otherwise use `.agents/context/project.md`.
4. Inspect only high-signal evidence needed to verify a stack decision:
   Project Context, repository guidance, existing environment metadata, and
   authoritative technology documentation when a current capability,
   compatibility, support, or license claim matters.
5. If the Project Context is missing, incoherent, or materially stale, pause
   stack selection and report that condition rather than inventing project
   requirements.

## Decision method

For every candidate, connect the choice to a project need before selecting it.
Consider only criteria that matter to the project, such as:

- functional fit and supported workload;
- compatibility with stated inputs, outputs, and boundaries;
- reproducibility and evaluation support;
- operational and development constraints;
- security, privacy, licensing, and supportability;
- complexity, reversibility, and dependency cost; and
- evidence quality and remaining uncertainty.

Separate these two dimensions:

- **claim state**: `user-intent`, `observed`, `documented`, `inferred`,
  `unknown`, or `conflicted`;
- **selection status**: `selected`, `experimental`, `deferred`, or
  `excluded`.

Do not turn an inferred preference into a selected stack without showing the
inference and its uncertainty. Do not present an experimental technology as a
baseline dependency.

## Implementation simulation

The simulation is a short thought experiment, not an implementation plan. For
each selected or experimental choice, explain:

1. what future implementation capability would need it;
2. what role the technology would play at a conceptual level;
3. what evidence would validate the choice; and
4. what limitation, trade-off, or likely replacement point remains.

Keep the simulation technology- and outcome-focused. Do not invent source
files, classes, endpoints, commands, deployment manifests, or task sequences.

## Interactive workflow

Use this sequence:

`inspect -> assess -> show board -> ask -> compare -> simulate -> preview -> confirm -> write -> validate`

Do not dump a long questionnaire. Ask no more than three related questions in
one round, prioritizing questions that could change a stack decision. Show the
user which choices are blocked, provisional, or safe to defer.

Before writing, show:

- the Stack Context readiness board;
- the selected, experimental, deferred, and excluded choices;
- the implementation simulation summary;
- the material trade-offs and unresolved decisions;
- the proposed Stack Context status; and
- the exact files that will be created or updated.

Write only after the user confirms the preview. Use relative links, verify
them, and preserve existing context files. If a canonical index exists, add
the Stack Context entry without rewriting unrelated entries. If no convention
exists, use `.agents/context/stack.md` and the repository's existing context
index convention.

## Handoff

Finish by reporting:

- the Stack Context and index paths;
- the readiness status: `draft`, `needs-review`, `ready`, or `stale`;
- the selected stack and its decision rationale;
- what was simulated and what was intentionally left to Implementation
  Context;
- deferred decisions, trade-offs, and evidence gaps; and
- the next context-aware action: Implementation Context may elaborate the
  selected stack, validate versions, define interfaces, and make implementation
  decisions within these boundaries.

Never claim that the stack is implementation-ready merely because the Stack
Context file exists.
