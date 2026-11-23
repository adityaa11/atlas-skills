# Reuse and centralization guide

Use this guide during ticket planning to prevent independently created copies
of the same capability without forcing unrelated behavior into a generic
abstraction.

## Evidence-first comparison

Inspect only the selected work package, direct dependencies, and high-signal
code neighbors. For a proposed shared function or component, compare:

- purpose and observable behavior;
- input parameters/props, output/return data, and error semantics;
- authority, trust, tenancy, identity, and policy boundary;
- lifecycle and activation/composition owner;
- persistence, transaction, retry, idempotency, and observability needs;
- UI information meaning, accessibility, interaction states, and visual
  contract when the capability is frontend-facing; and
- actual existing consumers plus directly planned consumers in accepted scope.

Do not infer sameness from code shape, duplicated syntax, matching filenames,
or a speculative future use.

## Decision rules

### `reuse-existing`

Choose when an existing abstraction has the same semantic contract and can be
consumed without widening its authority or weakening validation, UI meaning,
or lifecycle constraints. Record the exact exported contract and boundary.

### `extract-shared`

Choose when two or more accepted current or directly planned consumers require
the same behavior and contract, and one shared owner reduces divergence without
obscuring meaningful differences. Define a focused function/component API:
named inputs, output/return type, error behavior, side-effect ownership, and
consumer-specific extension boundary. Make creating the shared abstraction a
dependency before consumers rely on it.

### `keep-local`

Choose when superficially similar code has a material difference in domain
meaning, trust/authority, policy, lifecycle, failure/retry semantics,
persistence, performance, UI information hierarchy, interaction/accessibility,
or visual contract. State the difference and boundary that would be lost by
centralizing.

### `planning-required`

Choose when the correct owner, cross-domain contract, architectural layer, or
policy cannot be selected from accepted context. Do not introduce a global
utility, catch-all service, registry, or generic component; return the choice
to planning.

## Ticket placement

Put an extraction in its own ticket when it creates a reusable contract used
by separately reviewable consumers or changes an architectural boundary. Keep
it within a consumer ticket only when it serves one bounded outcome and does
not create a new independently consumed contract.

Every extraction ticket must say whether it is preparation-only or active, name
the consumers, and provide a real entrypoint-to-endpoint proof for any active
path. Every consumer ticket must use the published contract rather than
reimplementing it locally.
