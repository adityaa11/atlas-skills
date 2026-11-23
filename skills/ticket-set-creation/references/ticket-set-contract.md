# Ticket-set contract

## Purpose

This reference defines the minimum ticket-set artifact needed to convert an
accepted Implementation Context milestone or explicitly authorized bounded
scope into executable Atlas tickets. It does not supersede the shared Atlas
Review Contract or Artifact Store Contract.

## Set index

The ticket-set index is the entry point. It records:

- set ID, status, artifact revision, and selected milestone/work-package IDs;
- source Project, Stack, and Implementation Context references;
- architecture/decision records and direct predecessor outputs consumed;
- ticket registry: ID, title, lifecycle state, dependency IDs, and whether
  work is required sequence or parallel-safe;
- entrypoint -> endpoint -> handoff graph across tickets;
- activation registry, including preparation ticket and activation successor;
- expected-use-path registry, mapping each material production artifact to its
  planned caller, endpoint, consumer/effect, and required future evidence;
- reuse-decision registry, including shared-contract owners and consumers;
- context-refresh, planning, UI, and security blockers; and
- the next eligible ticket(s), with prerequisites for GO.

Use stable IDs. Preserve superseded ticket history and mappings; do not reuse
an old ticket ID for a materially different contract.

For a planning amendment that touches several tickets, identify one owner of
each new implementation contract in the existing ticket registry/handoff
records. An older ticket records only its superseded restriction, retained
obligations, and owner handoff; a consumer records its own acceptance checks.
Do not copy the owner's full requirements into either record. Record why a new
ticket is needed instead of amending the active one. Audit findings with an
accepted future disposition do not require a current repair ticket.

## Ticket schema

Each ticket contains the following, omitting only a genuinely inapplicable
section with a stated reason:

```md
# <TICKET-ID> — <bounded outcome>

- State: planned | ready | in-progress | awaiting_review | approved | blocked | superseded
- Batch / milestone / work-package trace:
- Source authority:
- Dependencies and accepted predecessor outputs:
- Successors and handoffs:
- Activation: active-in-this-ticket | preparation-only | not-applicable
- Reuse decision(s): reuse-existing | extract-shared | keep-local | planning-required
- Legacy path: forbidden | explicitly-authorized (with consumer and retirement trigger)
- SQL change classification: intended-migration | production-data | ephemeral-test-setup | not-applicable
- Empty/initial-state contract: required for data-dependent work | not-applicable

## Outcome
## Exact scope
## Entrypoint
## Endpoint
## Handoffs
## Expected use-path
## True code path and legacy record
## SQL migration hygiene
## Empty and initial state
## Required invariants
## Explicit non-goals
## Reuse and centralization decision
## Review Contract
## Security readiness
## UI readiness (when applicable)
## Validation and evidence
## Hard stop / planning findings
```

### Entrypoint record

State the caller/composition owner, module or function, inputs, input type or
schema, trust/provenance, validation responsibility, and error result. If the
entrypoint is dormant preparation, say who will invoke it later and name that
ticket.

### Endpoint record

State the observable output boundary, exact output type/schema or persisted
effect, owner, result/error semantics, and activation proof. Do not call an
unreachable helper an endpoint.

### Handoff record

For each cross-component/ticket transfer, state:

```text
Handoff ID:
Producer ticket and function/endpoint:
Consumer ticket and entrypoint:
Transport/storage mechanism:
Data schema/type and required fields:
Identity, integrity, correlation, ordering, idempotency, and retry semantics:
Activation status and proof:
```

### Expected use-path record

Every material production artifact has a stable expected-use-path record:

```text
Expected use-path ID:
Production artifact and owner:
Planned composition caller:
Expected entrypoint and input:
Expected internal function/component chain:
Expected endpoint/output:
Planned consumer or user-visible/system effect:
Expected activation state:
Required actual-use evidence:
```

The expected chain must end at a planned scoped consumer or observable effect.
A unit test is supporting proof, not a consumer. Ticket-set creation records a
contract and required evidence; it does not claim the implementation exists.
GO/CFC report the actual use path in their checkpoints, CK verifies the actual
path against this record, and HMN relies on that evidence without changing the
expected contract. If the artifact is preparation-only, name the immediate
consuming/activation ticket, accepted reason for deferral, and handoff. If
those facts are absent, merge the work with the consumer ticket or mark the
plan not-ready.

## Review Contract rows

Each row has a stable ID and records:

```text
Authority reference:
Requirement type:
Required behavior:
Entrypoint/endpoint/handoff affected:
Required harness, scenarios, and observations:
Evidence locator and expected result:
Forbidden substitutes:
Direct-regression boundary:
```

Use binary phrasing: `PASS iff ...`; name the direct negative when useful.
Include requirements for interface reachability and production activation when
the ticket's activation state is `active-in-this-ticket`. A generic unit test
does not prove an integration handoff when the accepted scope requires an
actual runtime route, queue, worker, UI flow, or persistence transition.
Do not create a production function or export only to make a unit test pass.

## Workflow reporting responsibilities

- **Ticket set:** freezes `ExpectedUsePath` and required actual-use evidence.
- **GO:** records the actual implementation path, code locations, executed
  evidence, and any mismatch before handoff.
- **CK:** acts as independent QC/QA: traces the committed actual path from
  composition to consumer/effect and decides whether it satisfies the frozen
  expected path. A unit-only path is not sufficient.
- **CFC:** maps any authorized repair to the same expected path and records
  actual remediation evidence without redefining it.
- **HMN:** uses the ticket, checkpoint, and CK evidence to diagnose/authorize
  a bounded continuation; it cannot redefine the expected path.

## True code path and legacy record

For a ticket that replaces or activates behavior, record:

```text
True operational path after change:
Superseded paths to remove or make unreachable:
Retirement proof required from GO/CFC and CK:
Legacy status: forbidden | explicitly-authorized
```

An explicitly authorized legacy path additionally records its consumer,
preserved contract, duration or retirement trigger, owner, and verification.
Prior ticket approval alone is never legacy authority.

## SQL migration hygiene

For every persistence ticket, record:

```text
SQL change ID:
Classification: intended-migration | production-data | ephemeral-test-setup:
Authority and real operational consumer:
Migration graph impact, when applicable:
Ephemeral setup/teardown mechanism, when applicable:
Required GO/CFC inventory and CK evidence:
```

`ephemeral-test-setup` must live outside the intended migration graph and be
cleaned up by the test mechanism. A test-only seed migration or conditional
migration branch is forbidden. `production-data` is allowed only when the
accepted ticket requires it in a real path, not as a test fixture.

## Empty and initial state

For each data-dependent boundary, record:

```text
Empty-state ID:
Data/tenant/query scope:
Condition (new database, no rows, absent record, or first use):
Entrypoint and expected endpoint/UI/system result:
Permitted initialization and idempotency rule:
Forbidden hidden default or durable test seed:
First successful handoff after initialization, when applicable:
Required GO/CFC and CK evidence:
```

This is a product/system contract, not permission to invent a default. When
accepted context does not specify the material empty behavior, mark the ticket
blocked for planning. Test it with ephemeral setup rather than a durable seed.

## Security and UI mapping

Security readiness records only the scoped results from
`engineering-security-refactor-readiness`. Map `implement-now` items to Review
Contract rows and evidence; map `preserve-seam` to invariants/exclusions and
their boundary evidence; keep `deferred-policy` as a hard stop or explicit
planning finding.

For UI work, reference the selected `frontend-awareness` findings. Map only
ticket-authorized visual, interaction, responsiveness, accessibility, CSP, or
browser-execution requirements into Review Contract rows. Do not convert
generic frontend advice into ticket scope.

## Reuse and centralization mapping

Record a `ReuseDecision` for each material capability that appears or could
appear in more than one selected work package. A decision contains:

```text
Reuse decision ID:
Capability and semantic contract:
Repository/context evidence inspected:
Decision: reuse-existing | extract-shared | keep-local | planning-required
Authority/trust/lifecycle comparison:
Owner and supported consumers:
Function/component parameters or props and return/output contract:
Error semantics and direct-regression boundary:
Affected ticket(s) and handoff IDs:
```

A shared function/component must have a bounded, explicit contract and a
named owner. A consumer must not duplicate the same capability merely because
its implementation lives in a different file. Conversely, do not centralize
behavior with different authority, policy, lifecycle, failure semantics, or UI
meaning: preserve those local boundaries and record `keep-local`.

## Sizing test

A ticket is appropriately sized only when it can provide a coherent output and
complete its named proof in one GO checkpoint. Split if CFC would need to make
an unrelated authority decision or if review evidence would conceal independent
failures. Merge only when the components share one authority boundary,
completion signal, and proof path.
