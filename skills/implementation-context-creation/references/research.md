# Implementation research protocol

Use this protocol for research that affects implementation feasibility,
architecture, compatibility, security, operations, verification, or sequencing.
Research is a decision aid, not an excuse to expand scope or collect links.

## Research loop

1. **Frame the question** - express it as a decision or verification question
   that can change a milestone phase, boundary, risk treatment, or acceptance
   gate.
2. **Set the stopping condition** - define what evidence is enough to decide,
   defer, or mark the question inconclusive.
3. **Choose sources** - inspect repository evidence first, then Project/Stack
   Context, then authoritative primary documentation, standards, source code,
   or controlled experiments as appropriate.
4. **Check scope and freshness** - record version, date, environment, region,
   license, or workload assumptions when the claim depends on them.
5. **Compare the smallest useful set** - include alternatives only when they
   could change the implementation decision.
6. **Translate the finding** - state the milestone impact, decision status,
   verification consequence, and residual risk.
7. **Record and stop** - preserve the source, claim state, confidence, and
   follow-up trigger. Do not keep researching after the stopping condition is
   met.

## Evidence quality

Prefer, in order appropriate to the question:

- observed repository behavior, tests, build metadata, and environment facts;
- explicit Project Context or Stack Context decisions;
- official product, library, provider, or standards documentation;
- reproducible experiments or benchmarks in the relevant environment;
- credible secondary analysis for context or comparison; and
- search results only as leads to sources that are then inspected.

For current or unstable claims, verify with fresh authoritative sources. For
security, privacy, licensing, support, and compatibility claims, do not rely
on memory or an uninspected summary.

## Research record

Use a compact record such as:

```text
Research ID: R-01
Question: Can the selected integration meet the required delivery guarantee?
Why now: The integration phase cannot choose its retry and reconciliation gate
without this answer.
Sources inspected:
- [repository path or URL] - [what was checked]
Finding: [concise result and applicable scope]
Claim state: documented | observed | inferred | unknown | conflicted
Impact: [phase, decision, interface, test, or operational consequence]
Decision status: confirmed | proposed | experimental | deferred | blocked
Confidence: high | medium | low
Follow-up: [owner/trigger, or none]
```

Never cite a source that was not inspected. Keep source quotes short; prefer
paraphrase with a link or repository path. If evidence conflicts, show the
conflict and its effect instead of averaging it away.

## Experiments and prototypes

Use a prototype or benchmark only when it can answer a bounded question. Define
the environment, inputs, success measure, limitations, and disposal or
promotion decision. A prototype validates an assumption; it does not become a
baseline implementation automatically.

## Research handoff

At the end of the Implementation Context, summarize:

- findings that changed the phase shape or technical decision;
- evidence gaps that remain non-blocking;
- questions that block a phase and their owner or trigger; and
- what execution planning must revalidate as the repository or external
  technology changes.
