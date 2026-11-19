# Milestone ordering discipline

Use this method to determine the order of milestones and candidate work
packages. It selects an order from the project’s end-product path and evidence;
it does not impose a universal development lifecycle.

## 1. Classify the project state

Classify from inspected evidence, not directory names:

- `greenfield` — no authoritative production behavior, data, runtime, or
  interface must be preserved;
- `existing-code` — current code, data, integrations, or users establish
  behavior that implementation must preserve, replace, migrate, or retire; or
- `hybrid` — some parts are authoritative while prototypes, fixtures, or new
  areas are not.

If the evidence is insufficient, record the uncertainty and ask a focused
question. Do not treat prototype, generated, or dormant code as authoritative
without evidence.

For `existing-code` and `hybrid`, map only the material current state: live
capabilities, entry points and interfaces, data/state, runtime/deployment
boundaries, external dependencies, tests or operational signals, and the
behavior that each planned change must preserve, replace, or retire.

## 2. Start from the end product

Map each required end-product capability or acceptance signal to the trusted
state, interface, policy, data, and verification it requires. Work backwards to
identify candidate work packages. Every milestone must state:

- why it exists now;
- the end-product capability, trusted state, or delivery constraint it unlocks;
- what remains unavailable until it passes; and
- the evidence that proves the next milestone may rely on it.

Do not create milestones merely because a source document has sections named
frontend, backend, database, testing, or deployment.

## 3. Build the partial order

Add an ordering edge only when evidence supports one of these relations:

- `sequence` — a predecessor produces a capability or artifact required by the
  successor;
- `interface prerequisite` — a consumed interface, data contract, or trusted
  state must exist first;
- `decision gate` — a material choice, policy, or compatibility result must be
  known before committing dependent work;
- `preservation/replacement` — current behavior, data, or an external consumer
  must be characterized, kept compatible, migrated, or retired before a change;
- `verification prerequisite` — required test, observation, or safe rollback
  basis must exist before a risky or irreversible change; or
- `parallel-safe` — no supported ordering edge exists.

Do not convert a preference, a role sequence, or a generic lifecycle stage into
a dependency.

## 4. Choose the next eligible milestone

Among packages whose hard predecessors are satisfied, prefer the smallest
related set that best balances:

1. progress toward a required end-product capability;
2. early resolution of high-impact uncertainty, safety risk, or irreversible
   commitment;
3. bounded change impact and a credible rollback/containment posture; and
4. a reviewable proof that makes later work safer or more certain.

This is a tie-breaker, not a numeric score. Keep independent eligible work
parallel-safe. Do not create a broad “foundation” milestone unless its output
is actually consumed by several later packages or it resolves a material risk.

## 5. Apply the project-state rules

For `greenfield`, establish only the enabling work needed to validate the
earliest valuable or risky end-product capability. Prefer vertical capability
slices over disconnected technical layers.

For `existing-code` and `hybrid`, first establish characterization tests,
compatibility seams, data migration/rollback posture, or observability only
when they are necessary to change a material live boundary safely. Preserve
existing behavior by default; record explicit replacement or retirement where
the target product requires change. Sequence migrations and cutovers after the
new path and its verification are available, unless evidence justifies another
order.

## 6. Reassess at evidence boundaries

After a research result, decision, prototype, migration rehearsal, or milestone
gate, reconcile the graph. Update dependencies, preservation/replacement maps,
and parallelism when evidence changes them. Do not silently keep the original
order when its assumptions no longer hold.
