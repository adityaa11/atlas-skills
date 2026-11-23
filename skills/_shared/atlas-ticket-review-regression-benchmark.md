# Atlas Review Workflow Regression Benchmark

This benchmark replays recorded Atlas review artifacts against the shared
Review Contract. It checks that CK's target stays stable, HMN authorizes only
the exact unresolved target, CFC closes every authorized clause, and CK's final
decision follows the evidence. Historical artifacts remain unchanged.

## Case A: IDSER-005 final HMN-authorized remediation

Sources:

- `project's goal/feedback/IDSER-BATCH-05-17ce58d-verification.md`
- `project's goal/feedback/IDSER-005-hmn-009.md`
- `project's goal/feedback/IDSER-BATCH-05-2707518-verification.md`

Input state: only original clauses `CK-002.a` through `CK-002.e` are open;
`CK-001` is resolved. CK's verification names missing queued-job/thrown-error
redaction evidence and the bounded cancellation outcome.

Expected HMN behavior: authorize only those five clause IDs and reference the
CK artifact. HMN must not copy the closure criteria into a second checklist.

Expected CFC behavior: read the exact payload/error/cancellation gaps from the
CK artifact; use the existing production-path integration harness; record
exact command results and a proof locator for each clause; hand off only after
all five closure oracles pass.

Expected CK behavior: evaluate only the five frozen clauses and direct
regressions. The recorded result is `PASS` at `2707518` because every clause is
marked resolved, the evidence is mapped clause by clause, and no direct
regression is reported.

Benchmark result: **PASS**. This proves one recorded final HMN -> CFC -> CK
cycle converged. HMN-009 repeated some CK detail; the current rule removes that
duplication and makes the referenced CK artifact the sole closure source. This
does not prove an arbitrary implementation will pass.

## Case B: HMN adds a stronger checklist

Input state: CK reports one unresolved frozen clause with a defined closure
oracle. HMN proposes additional scenarios or assertions that are not in that
clause or the frozen ticket.

Expected HMN behavior: omit those additions from the authorization, or record
them as a scope/review-contract issue. Do not make them CFC readiness gates.

Expected CFC behavior: follow the frozen closure oracle. Diagnostic probes may
be included, but their absence cannot block readiness.

Expected CK behavior: do not require HMN-only additions to award `PASS`.

Benchmark result: **PASS** only if the extra conditions never become blocking
acceptance criteria.

## Case C: a frozen oracle remains false

Input state: CFC claims readiness, but one authorized clause's named assertion
or required validation fails or is missing.

Expected CFC behavior: remain `CFC_NOT_READY_FOR_CK`; record the exact failed
oracle and continue the same authorized cycle.

Expected CK behavior after an improperly handed-off checkpoint: return
`CHANGES_REQUIRED` for that same clause, naming expected state, actual state,
and evidence location. Do not add a new condition.

Benchmark result: **PASS** only if the workflow refuses a false readiness claim
and preserves the clause as the sole repair target.

## Case D: direct regression

Input state: all original clauses close, but the remediation directly breaks
ticket-required behavior in the authorized scope.

Expected CK behavior: return `CHANGES_REQUIRED` for the direct regression with
the affected ticket row and evidence. Existing closure proof is preserved.

Benchmark result: **PASS** only if direct regressions remain blockable.

## Case E: planning-authorized supplemental contract-gap recovery

Input state: CK returned `REVIEW_CONTRACT_GAP`; human/planning authority
durably authorized a supplemental ticket-bound freeze; CK froze stable,
unresolved supplemental clauses with direct ticket traces and binary oracles
without changing historical clauses; and a newer explicit HMN invocation
authorized `AUTHORIZE_EVIDENCE_REMEDIATION` for only those supplemental IDs.

Expected HMN behavior: authorize only the unresolved supplemental clause IDs
when no product, scope, architecture, or policy decision remains. Ordinary
gaps without the planning decision and supplemental freeze remain
non-authorizing.

Expected CFC behavior: accept the supplemental artifact as the oracle source
only after validating all prerequisites and non-supersession; protect all
historical resolved clauses; remediate only the HMN-selected supplemental
clauses; record the consumed HMN ID; and hand off one bounded checkpoint to CK.

Expected CK behavior: verify only the selected supplemental clauses, required
evidence, remediation diff, and direct regressions. Preserve historical
resolved outcomes. Return `PASS` only when all original and supplemental
ticket-derived clauses are proven and no direct regression remains; otherwise
return to human/planning authority without starting another CFC cycle.

Benchmark result: **PASS** only if ordinary `REVIEW_CONTRACT_GAP` still cannot
authorize CFC and every supplemental gate and scope boundary is enforced.

## Case F: valid Route A planning-authorized historical-oracle replacement

Input state: an original CK clause remains unresolved after CFC verification;
HMN durably records that its frozen oracle conflicts with approved
implementation authority and that satisfying it would require unapproved
functionality; a subsequent explicit planning amendment identifies the exact
superseded ticket requirements, replacement requirements, and reason; and the
amendment leaves unrelated obligations binding.

Expected CK behavior: create an append-only replacement-contract freeze only
after validating those prerequisites. The artifact maps the historical clause,
original ticket authority, planning amendment, supersession reason, stable
replacement IDs such as `RCK-001.a`, exact active obligations, required proof,
and binary closure oracles. The freeze is not `PASS`, does not verify an
implementation checkpoint, and does not authorize CFC.

Expected HMN behavior: require a fresh explicit invocation after the freeze and
authorize at most one `AUTHORIZE_EVIDENCE_REMEDIATION` cycle naming only
unresolved replacement clause IDs. Historical outcomes and all unrelated
original obligations remain protected.

Expected CFC/CK behavior: consume the exact replacement freeze and newer HMN
authorization, prove only the authorized replacement clauses, verify the
remediation diff and direct regressions, and issue `PASS` only after every
still-applicable original obligation and every active replacement obligation is
proven.

Benchmark result: **PASS** only if the historical failure remains visible, the
superseded portion is no longer an impossible active gate, and no other
original obligation is weakened.

## Case G: replacement eligibility rejection

Run these negative inputs independently:

- no explicit planning amendment exists;
- the frozen oracle is merely difficult, unproven, or failed but remains
  achievable under approved authority;
- the HMN authority-conflict diagnosis is missing or does not name the exact
  oracle and unapproved functionality; or
- the replacement artifact has no exact binary oracle, stable replacement ID,
  or active-obligation mapping.

The following Route B-specific inputs must also be rejected:

- no original CK artifact froze the clause unresolved;
- CFC did not durably record `CFC_NOT_READY_FOR_CK`, or created a remediation
  commit or CK handoff instead;
- no independent HMN authority-conflict diagnosis exists; or
- the claimed conflict is only missing environment evidence, an unexecuted
  check, or an achievable but failed test.

Expected behavior: reject the replacement freeze and return control to
human/planning authority. Do not authorize CFC, reinterpret the original
clause, or create an automatic retry.

Benchmark result: **PASS** only if every negative input is rejected.

## Case H: unrelated-obligation and historical-ID protection

Input state: the planning amendment attempts to weaken, omit, renumber, or
replace an unrelated original obligation, or reuses a historical `CK-###` or
`CK-###.a` identifier.

Expected behavior: reject the replacement freeze. A valid replacement maps only
the explicitly superseded portion, uses a distinct stable replacement namespace,
and carries every other original obligation forward unchanged. HMN and CFC may
not authorize the historical clause ID or reopen historically resolved clauses.

Benchmark result: **PASS** only if unrelated requirements and historical IDs
remain protected.

## Case J: valid Route B pre-CFC non-remediable authority conflict

Input state: an original CK artifact froze one clause unresolved. CFC attempted
that clause and durably recorded `CFC_NOT_READY_FOR_CK` without a remediation
commit or CK handoff because its frozen oracle requires behavior or evidence
outside approved authority. HMN independently recorded the exact conflict and
returned it to human/planning authority. A subsequent planning amendment maps
only the superseded portion, preserves unrelated obligations, and identifies
replacement requirements.

Expected CK behavior: independently validate all six Route B prerequisites,
then create an append-only replacement freeze with stable `RCK-###.a` IDs,
exact active obligations, required proof, and binary closure oracles. The
freeze is not `PASS`, is not an implementation checkpoint, and does not
authorize CFC.

Expected HMN/CFC behavior: a fresh explicit user `hmn` invocation is still
required after the freeze. It may authorize only unresolved replacement IDs;
the historical clause ID is never an authorization target. CFC does not run
from the incomplete progress record or the freeze alone.

Benchmark result: **PASS** only if Route B resolves the circular prerequisite
without changing ordinary Route A, supplemental-gap, CK, CFC, HMN, or R3
boundaries.

## Case I: existing-path and final-proof regression protection

Input state: exercise the existing `REVIEW_CONTRACT_GAP` supplemental path, an
ordinary `CHANGES_REQUIRED` cycle, a frozen-oracle failure, a resolved-clause
protection case, and a replacement cycle where one active replacement oracle
is still false.

Expected behavior: the supplemental path remains independent; ordinary
`CHANGES_REQUIRED` still uses the original frozen oracle; resolved clauses are
not reopened; each additional CFC cycle still needs one fresh explicit HMN
authorization; and final `PASS` is denied until actual evidence proves every
active replacement clause plus every still-applicable original obligation.
There is no new lifecycle state and no autonomous retry.

Benchmark result: **PASS** only if all existing behavior is preserved and a
false active replacement oracle remains `CHANGES_REQUIRED`.

## Case K: planning changes a ticket after failed CK

Input state: CK failed an explicit no-upload boundary. Before any CFC checkpoint
is reviewed, human/planning authority explicitly authorizes a bounded upload
contract that supersedes only that boundary, preserves unrelated security and
UI obligations, and authorizes revised GO implementation.

Expected behavior: GO records the amendment ID, exact changed/retained rows,
historical CK reference, new code commit, and proof. CK performs one full first
review against the effective ticket. The historical failure remains visible;
its superseded oracle is not an active gate. A replacement freeze and fresh HMN
are not required merely to carry the new product scope. Missing authorization,
an unmapped supersession, or an unrelated weakened obligation blocks this path.

Benchmark result: **PASS** only if the changed scope receives independent full
review without treating the old CK result as either erased or CFC-closed.

## Case L: repair dependency and consumer amendment

Input state: ticket B exists to repair a gap found in ticket A, which has CK
`CHANGES_REQUIRED`; ticket C consumes B's handoff. A draft makes B depend on A
CK `PASS` and copies B's full new proof matrix into C.

Expected behavior: ticket planning rejects the dependency cycle. B may inspect
A's exact committed implementation/evidence and prove direct regressions, but
does not promote A to `PASS`. One planning decision may map B and C separately:
B gets its own new obligations; C names only its changed consumer handoff and
review checks. Neither ticket silently inherits scope. Unrelated repairs need
separate authority, not a mandatory one-ticket-per-finding rule.

Benchmark result: **PASS** only if the cycle and copied contract are removed
without waiving A's independent acceptance or C's own required proof.

## Case M: reusable visual baseline with a combined capture harness

Input state: a prior committed baseline capture has an exact artifact
commit/path/blob and source-code binding. Its reference source, viewport and
capture settings are unchanged. Implementation code changed and needs a current
capture. The required test harness automatically writes both images when its
capture output is set.

Expected GO behavior: run the required harness with isolated temporary output,
commit the current implementation capture, reference the prior baseline by its
immutable locator and observation context, and record current validation and
change analysis. An unrelated assertion edit does not force a new baseline.
CK verifies both proof identities and rejects a stale implementation image.
If the ticket explicitly mandates a fresh independent baseline capture, GO
commits one and does not substitute the reference.

Benchmark result: **PASS** only if no redundant baseline path is committed and
no current-state or frozen capture obligation is skipped.

## Case N: one owner after a conflicting scope amendment

Input state: an active UI ticket forbids upload; CK correctly fails an
unauthorized upload. The user then authorizes a local storage capability with
a distinct storage boundary. A draft planning decision amends the UI ticket
with a full storage contract, creates a storage ticket with the same contract,
and copies both matrices into a downstream review ticket.

Expected planning behavior: keep the historical CK failure; name the storage
ticket as the single implementation/acceptance owner and explain the distinct
boundary. The UI ticket records only its superseded no-upload restriction,
retained UI/security obligations, and storage handoff. The downstream review
ticket names only its own handoff and regression checks. Each ticket receives
its own CK result; storage CK `PASS` does not approve the UI or review ticket.
If the authorized change stays within the active ticket's coherent outcome and
authority, amend that ticket instead of creating a new one solely because CK
failed. Missing scope authority or unrelated weakened obligations still stop.

Benchmark result: **PASS** only if one ticket owns the new implementation
contract, necessary independent reviews remain, and no copied proof matrix or
automatic approval appears in the other tickets.

## Case O: audit findings and related repair ownership

Input state: an audit reports six findings. One requires current implementation
repair; the other five have explicit accepted successor deferrals. A browser
test also needs maintenance to prove the repaired behavior. A draft creates a
repair ticket for every finding and a separate mandatory ticket for the test.

Expected planning behavior: audit CK `PASS` accepts the report only. The five
deferred findings retain named successors and create no current repair tickets.
The current repair and its directly required test maintenance may share one
bounded owner ticket if the authority, outcome, and regression proof fit;
otherwise the split records the independent boundary. The consuming review
ticket verifies the approved handoff and unresolved dispositions independently.

Benchmark result: **PASS** only if ticket count follows distinct authorized
outcomes rather than finding count, and no audit or repair PASS is promoted into
consumer or milestone acceptance.

## Applying the benchmark

When changing GO, CK, CFC, HMN, or the shared contract, review each case and
record whether the current rules produce the expected outcome. A benchmark
failure requires fixing the protocol before relying on it for another ticket.

## Application record

Run date: `2026-10-29` (Asia/Bangkok)

| Case | Result | Evidence of replay |
| --- | --- | --- |
| A–E | **PASS** | Existing HMN, CFC, CK, false-oracle, direct-regression, and supplemental-gap rules remain stated and bounded. |
| F | **PASS** | Route A remains unchanged: valid replacement requires durable authority conflict, later planning amendment, append-only mapping, fresh HMN, exact replacement proof, and final active-obligation closure. |
| G | **PASS** | Missing amendment, achievable oracle, incomplete diagnosis/matrix, or any missing/unsafe Route B prerequisite rejects the path. |
| H | **PASS** | Unrelated obligations and historical clause IDs remain protected. |
| I | **PASS** | Existing recovery behavior remains independent; a false active replacement oracle cannot produce `PASS`. |
| J | **PASS** | Route B permits CK to independently freeze only a demonstrated pre-CFC non-remediable authority conflict; a fresh HMN authorization remains required before CFC. |

Complete benchmark result: **PASS**. This is a protocol regression replay; it
does not execute or approve any IDSER workflow, BSS-QAP replacement freeze, or
R3 action.

## Application record — planning amendment path

Run date: `2026-11-23` (Asia/Bangkok)

| Case | Result | Evidence of replay |
| --- | --- | --- |
| A–E | **PASS** | Existing frozen-oracle, direct-regression, and supplemental-gap rules still apply when the ticket contract has not changed. |
| F–J | **PASS** | Replacement recovery remains available for its demonstrated authority conflict and keeps historical clauses, independent CK freeze, and fresh HMN prerequisites. Materially changed scope uses Case K instead. |
| K | **PASS** | The planning-amendment rule requires explicit changed/retained rows, implementation authorization, new source-bound checkpoint, full CK review, and immutable historical failure. |
| L | **PASS** | Ticket creation checks repair dependency cycles and permits one decision with per-ticket deltas while preserving separate handoff and acceptance authority. |
| M | **PASS** | Evidence reuse identifies the immutable baseline, requires current implementation proof, and lets a combined harness write temporary output without committing duplicate baseline paths. |
| N | **PASS, rule-level** | The single-owner rule gives the new capability one contract owner, limits older/consumer tickets to their own deltas, and preserves separate CK decisions. |
| O | **PASS, rule-level** | Audit findings require explicit dispositions; accepted future deferrals do not force current tickets, and related repair/test work may share one owner when bounded. |

Complete benchmark result: **PASS** by protocol replay. This record does not
execute a project ticket, approve a historical checkpoint, measure coordination
cost, or change an artifact repository.
