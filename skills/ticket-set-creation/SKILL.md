---
name: ticket-set-creation
description: Create a bounded Atlas ticket set from an Implementation Context milestone or an explicitly authorized user scope. Use to turn approved planning into dependency-ordered, reviewable implementation tickets; do not use for implementation, broad discovery, or changing project architecture.
---

# Atlas Ticket Set Creation

## Outcome

Create a durable ticket set whose tickets can each complete one bounded
`go -> ck -> cfc -> ck` flow without weakening the accepted product,
architecture, security, UI, or integration outcome.

The ticket set is a planning artifact. It does not implement code, approve a
ticket, issue `PASS`, or silently alter Project, Stack, or Implementation
Context decisions.

Read [the ticket-set contract](references/ticket-set-contract.md) before
creating or revising a ticket set.

## Resolve authority and source material

1. Resolve and validate the artifact store using the shared Atlas Artifact Store
   Contract. Read the Implementation Context entry-point index first.
2. Start from the user-named milestone/work package. If the user instead gives
   a bounded scope, map it to an existing milestone or work package before
   creating tickets. Do not invent a milestone or silently advance to one.
3. From the index, read only the selected milestone, its direct dependencies,
   relevant decision records, verification records, and execution-planning-map
   entries. Trace those records back to the required Project and Stack Context
   sections. Inspect only high-signal code, tests, runtime/configuration, and
   interface evidence needed to reconcile the selected scope with reality.
4. Preserve accepted architecture, dependency, fixture-replacement, runtime,
   and authority boundaries. If sources conflict, a necessary decision is
   unresolved, or repository evidence invalidates the plan, stop ticket
   finalization and record the exact planning finding and required context
   refresh.

The authority order is:

```text
accepted Project Context and explicit user authorization
> accepted Stack Context and Implementation Context decisions
> selected milestone/work-package contract and direct accepted dependencies
> repository evidence
> specialist-skill guidance
```

Specialist guidance improves the ticket design but never creates product scope
on its own.

## Reuse and centralization analysis

Before splitting tickets, read [the reuse and centralization guide](references/reuse-and-centralization.md).
Inspect the selected scope and its direct, high-signal code neighbors for
existing functions, modules, components, contracts, and composition seams that
already solve the same semantic problem. Compare behavior, input/output
contract, error semantics, authority/trust boundary, lifecycle, and consumers;
do not decide from similar names or files alone.

For each material repeated capability, write a stable `ReuseDecision` with one
of: `reuse-existing`, `extract-shared`, `keep-local`, or `planning-required`.
Record its evidence, owner, consumers, and why the decision preserves rather
than broadens the accepted architecture.

Prefer an existing shared abstraction when it already has the required
semantics. Extract a shared function/component only when at least two accepted
current or directly planned consumers have the same authority and lifecycle
needs and the shared contract can remain explicit. Keep an implementation local
when centralization would erase material domain, policy, trust, UX, lifecycle,
or error-handling differences. Never create a speculative utility, global
registry, or generic component solely because future reuse is imaginable.

When a shared abstraction is selected, the producing ticket declares its
function/component contract, named parameters/props, return/output data,
error semantics, owner, and consumers. Each consuming ticket declares its
entrypoint and the handoff to that shared contract. If extraction changes an
accepted architecture/interface boundary, stop for a planning decision instead
of silently refactoring it.

## Required specialist analysis

Run `engineering-security-refactor-readiness` for every candidate ticket or
for every proposed split whose trust, asset, authority, persistence,
integration, configuration, or execution boundary differs. Incorporate its
stable readiness IDs and only ticket-authorized `implement-now` controls into
the ticket review contract. Preserve `preserve-seam` items as invariants,
exclusions, or boundary requirements; retain `deferred-policy` items as
planning findings. A `planning-review-required` result blocks ticket
finalization.

Run `frontend-awareness` when scope creates or changes user-facing UI design:
information hierarchy, layout, visual tokens, component composition,
interaction states, accessibility outcome, or responsive transformation. Use
its project visual-contract and review-gate output to define relevant UI
requirements and evidence. Do not invoke it for backend-only or isolated
browser implementation work without a UI design change. A ticket may reference
the frontend analysis; it must not copy generic design guidance as unsupported
acceptance criteria.

For a specific browser API or compatibility decision, use
`modern-web-guidance` whether or not `frontend-awareness` applies. Record a
relevant guide as technical evidence, not as a new ticket requirement.

## Ticket boundaries and sizing

Each ticket is one independently reviewable change with a coherent outcome,
authority boundary, dependency boundary, and evidence strategy. It must be
small enough for one complete GO/CK/CFC/HMN lifecycle, yet broad enough to
produce a real, reviewable outcome rather than a disconnected code fragment.

Before allocating a ticket for an amendment or review finding, apply the
shared Review Contract's single-owner rule. Decide whether the current active
ticket can absorb the authorized change or a distinct ticket is necessary;
record the reason for a new ticket. Name one implementation/acceptance owner
for each new capability or repair. In the prior ticket, keep only the exact
supersession and handoff delta; in a consumer, keep only its own review checks.
Do not duplicate the owner's implementation and proof matrix across tickets.
In the existing ticket-set summary, briefly state the user outcome, the
smallest valid owner/change, any reused handoff, and the added validation cost
for each proposed extra ticket. A ticket whose only purpose is to restate an
amendment, duplicate accepted evidence, or satisfy a workflow bookkeeping
step is not justified. This is a planning check, not a new CK pass condition.

Before freezing dependencies, check whether a proposed repair ticket depends
on CK `PASS` from the failed ticket whose gap it resolves. Replace that cycle
with the exact committed implementation/evidence baseline it consumes, plus
the direct regression obligations, or return an unresolved authority question
to planning. Do not promote the failed ticket to `PASS` or waive its later
approval. When one planning decision changes several tickets, record one
append-only decision with an exact per-ticket row, dependency and handoff map;
make each affected ticket incorporate its applicable portion by stable ID.
Avoid repeating the producer's whole Review Contract in consumer tickets.

Split candidate work when it crosses independently reviewable boundaries such
as:

- contract/raw-input validation versus domain interpretation;
- trusted issuance/authorization versus consumption or dispatch;
- data schema/persistence versus a consumer's business behavior;
- transport preparation/receiver preparation versus production activation;
- UI information/interaction work versus unrelated backend authority changes;
- a policy or architecture decision versus implementation under that decision.

Do not split merely by layer, file, or convenient task count. Do not combine
multiple authority boundaries just to reduce ticket count. A split must record
the produced interface, its consumer, direct dependency, and exact acceptance
handoff.

An audit may report several findings without requiring one repair ticket per
finding. Group directly related corrections in one bounded ticket when they
share the same accepted authority, implementation surface, and regression
boundary; split only when the distinct outcome or authority boundary requires
it. An audit ticket does not itself authorize those corrections.

## Clean entrypoint, endpoint, and handoff

Every implementation ticket must declare all applicable items below. These are
design and review obligations, not a demand to expose an HTTP endpoint.

- **Entrypoint:** the production or test composition point that invokes the
  work; caller/owner; module/function; exact input parameter names, types,
  provenance, and trust assumptions; and invalid-input/error behavior.
- **Endpoint:** the observable completion boundary: return value, persisted
  state, emitted event, registered route, queue publication, UI state change,
  or intentional no-side-effect result. State the exact result schema/type,
  owner, success/failure semantics, and evidence that it is reachable where
  production activation is in scope.
- **Handoff:** each output passed to another component/ticket: schema/type,
  required fields, ownership, integrity/identity/correlation fields, delivery
  mechanism, consumer, ordering/retry/idempotency expectations when relevant,
  and the successor ticket that activates or consumes it.

For generated code, prefer a named function or module boundary with explicit
input and output types. A ticket must name the function's parameters and
returned data contract at the level supported by accepted context; do not
invent exact internal APIs without that authority.

Every ticket must label activation as exactly one of:

- `active-in-this-ticket` - production composition reaches the endpoint and
  the ticket proves it;
- `preparation-only` - it creates a contract/seam but does not activate it;
  name the activation successor and prohibit dormant fallback paths; or
- `not-applicable` - no runtime activation exists, with a reason.

No ticket may claim completion for a production capability when it creates code
without an active entrypoint-to-endpoint path. If activation is intentionally
later, its successor must consume the named handoff and prove the integration.
The activation ticket must remove or reject obsolete compatibility paths unless
accepted authority explicitly preserves them.

## True code path and legacy discipline

For every ticket that replaces or activates behavior, define the single true
operational path after the change and name the superseded path(s) that must be
removed or made unreachable. A predecessor `PASS` protects accepted contracts
and invariants, not every former implementation branch. Do not preserve a
fallback, feature branch, wrapper, duplicate handler, or compatibility path
merely because it makes rollout or unit tests feel safer.

Include a legacy path only when the accepted Implementation Context or source
authority explicitly names the consumer, preserved contract, duration or
retirement trigger, and required verification. If those facts are absent,
legacy support is forbidden rather than deferred. Map this rule into expected
use paths and Review Contract rows so GO reports actual retirement, CK verifies
the true path, CFC fixes only frozen gaps, and HMN cannot restore a path by
preference.

## SQL migration hygiene

For every ticket that touches persistence, classify each proposed SQL change as
`intended-migration`, `production-data`, or `ephemeral-test-setup`. Intended
migrations are only durable schema/data evolution required by the accepted
operational path. Never plan a seed migration, SQL file in the migration graph,
or migration-runner conditional solely to support testing.

For `ephemeral-test-setup`, declare the isolated test mechanism and cleanup:
transaction rollback, disposable database/container, isolated schema, fixture
factory, or equivalent. It must not alter the intended migration graph. A
production-data seed is allowed only when accepted authority requires it for a
real consumer and names ownership and verification. Add migration inventory and
ephemeral-isolation evidence to the Review Contract so GO reports actual work
and CK verifies no test pollution.

## Empty and initial-state awareness

For every data-dependent ticket, identify the relevant empty condition: a new
database, new tenant/account, empty query result, absent optional record, or
first execution before any prior state exists. Declare the expected behavior at
the entrypoint and endpoint, whether initialization is allowed, the exact
empty/error/UI representation when applicable, mutation/idempotency rules, and
the first successful handoff after state is created.

Map this to an explicit Review Contract row and use ephemeral fixtures only to
prove it. Do not create a durable seed or hidden default merely to avoid
testing the empty state. If the accepted contexts do not decide what a user or
system should observe/do when empty, record a planning finding; do not invent a
product behavior.

## Expected use-path contract

Do not create a ticket for production code whose planned only caller is a unit
test. Before a ticket is finalized, define an `ExpectedUsePath` for every
material production function, component, route, worker, handler, adapter, or
shared abstraction:

```text
production composition/caller
-> named entrypoint
-> named function or component
-> observable endpoint
-> named consumer or user-visible/system effect
```

The ticket records the planned caller, each link, expected data/result, and
required future integration evidence. It does not claim that the path exists;
GO and CFC report the actual created path and evidence, CK independently
verifies it, and HMN only diagnoses/authorizes continuation from those records.
A unit test may prove a local invariant, but it never substitutes for required
actual use-path evidence.

`preparation-only` is valid only when accepted context explicitly requires a
sequenced contract/boundary and the record names its immediate activation or
consumer ticket, handoff, and proof. If there is no accepted reason to defer
use, merge preparation with the consumer/activation ticket rather than adding
an unused helper. A preparation ticket must not introduce a dormant fallback,
duplicate local implementation, or a production export created solely for
tests. Test harnesses, fixtures, and test-only helpers are allowed only when
they are explicitly test-scoped and are not represented as a production
capability.

## Write the ticket set

Write the ticket-set index and ticket records under the validated artifact
store, following its naming convention. The index identifies source contexts,
selected milestone, ticket status, dependencies, parallel-safe work, batch
order, and entrypoint/endpoint/handoff graph. Every ticket follows the schema
in the ticket-set contract and has stable identifiers for ticket, review rows,
security readiness, UI bindings when applicable, and handoffs.

Each acceptance requirement must trace to accepted authority. Convert it into
a binary Review Contract row with the required behavior, harness/scenarios,
observations, evidence, forbidden substitutes, and direct regression boundary.
This is the contract that GO implements and CK reviews; it must not require CK
to discover missing acceptance conditions.

For future tickets, specify which visual or other observations require a new
capture at the ticket's code revision and which stable comparison baselines may
be cited from committed evidence in the validated artifact store. Require a
fresh observation when accepted authority needs one; do not impose recapture
of an unchanged baseline merely by template habit. This planning choice does
not relax any already frozen ticket or its incorporated source contract.
Where a required harness produces both kinds of capture, specify an output or
capture mode that can collect current observations without repeatedly creating
the stable baseline. Keep the required test execution and review checks intact.

### Existing untracked artifacts

Ticket-set creation may proceed when the validated artifact store contains
pre-existing untracked artifacts, including files under `tickets/`,
`checkpoints/`, `feedback/`, or `evidence/`. Before any write, capture that
untracked-path inventory and reserve the exact paths this ticket set will
create. If a reserved path already exists, stop and report the collision.

Stage only the newly created ticket-set files and any directly related clean
index or manifest update. Do not stage, modify, or commit a pre-existing
untracked file. A pre-existing staged entry, tracked modification, deletion,
rename, or conflict remains a stop condition under the shared Artifact Store
Contract.

## Finalization gate

Before declaring a ticket set ready, verify that:

- every ticket has one bounded outcome, exact scope, exclusions, dependencies,
  and an explicit predecessor/successor handoff;
- every new capability or repair has one implementation/acceptance owner, and
  each additional ticket has a recorded distinct-outcome or authority reason;
- every material repeated capability has a `ReuseDecision`; selected shared
  abstractions have an owner, explicit contract, and named consumers;
- each required entrypoint, endpoint, and handoff is declared and traceable;
- every material production artifact has an `ExpectedUsePath` ending in a
  planned scoped consumer or effect; unit-only callers are insufficient;
- every active capability has an activation path and evidence, and every
  preparation-only capability names its immediate activation successor and
  accepted reason for deferral;
- every replacement/activation ticket defines one true operational path and
  the retirement of superseded paths, unless an explicit legacy record permits
  the named temporary compatibility path;
- persistence tickets classify SQL changes and prove that test-only setup is
  ephemeral rather than part of the intended migration graph;
- every data-dependent ticket declares its empty/initial-state contract and
  adequate first-use evidence, or is blocked on the required product decision;
- every Review Contract row traces to accepted authority and names adequate
  evidence; UI and security bindings are included only when applicable;
- the dependency graph agrees with every ticket's declared dependencies and
  distinguishes required sequence from parallel-safe work;
- no ticket is blocked by a planning/security/architecture decision or an
  unbounded interface; and
- each ticket can realistically reach `READY_FOR_CK` in one bounded pass.

If any condition fails, mark the set `not-ready`, identify the exact missing
decision or context refresh, and do not emit speculative executable tickets.

## Relationship to Atlas workflow

Ticket-set creation creates the frozen contract inputs. GO implements one
selected ticket, CK reviews its committed checkpoint, CFC remediates only
frozen CK findings, and HMN authorizes a bounded continuation when necessary.
Do not embed automatic GO/CK/CFC/HMN invocation or a second acceptance contract
inside this skill.
