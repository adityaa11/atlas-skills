# Implementation Context bundle

Use a bundle to keep detailed implementation context navigable and avoid
re-reading unrelated milestones. Prefer it when the context has multiple
detailed milestones or architecture/decision material that changes separately.

## Layout

Use repository convention when present. Otherwise use:

```text
.atlas/contexts/
├── implementation/index.md               # Compact entry point and routing index
└── implementation/
    ├── architecture.md                    # Architecture Overview
    ├── decisions.md                       # Decision Register
    ├── verification.md                    # Cross-phase verification/readiness
    ├── milestones.md                      # Milestone map and dependency spine
    └── milestones/
        ├── M1-<short-name>.md             # Detailed milestone/package map
        └── M2-<short-name>.md
```

`implementation.md` is the canonical entry point. The repository-wide context
index links to it. Do not make every child document a top-level context entry.

## Entry-point index

Keep the entry point concise. It may use YAML frontmatter and compact tables,
but must contain:

```text
Context ID / revision / status / project state / ticket-generation readiness

Read first:
- current or requested milestone path
- direct dependency paths
- named architecture, decision, or verification paths when relevant

Current execution:
- current or next milestone
- eligible package IDs
- blocking decision IDs
- required predecessor evidence

Milestone registry:
- stable ID | status | path | direct dependencies | read when

Decision registry:
- stable ID | status | path or anchor | affected milestones/packages

Change routing:
- package/interface change -> milestone and dependency records
- decision change -> decisions, architecture, affected milestones/readiness
- Project/Stack change -> stale assessment and affected records
```

Do not duplicate package detail, architecture prose, or verification matrices
in the index. Use stable IDs and relative links.

## Selective reading protocol

1. Read the entry point.
2. Resolve the requested or active milestone from its registry row.
3. Read that milestone, its direct predecessor milestone outputs, and only the
   architecture, decision, or verification records named for it.
4. Read more only when an explicit dependency, stale marker, or contradiction
   requires it.

Do not scan every milestone to create or implement one ticket. If the index is
missing, stale, or contradictory, repair or refresh it before relying on the
bundle.

## Update discipline

When a milestone/package, interface, architecture decision, or source context
changes, update the changed detail first, then reconcile the entry-point
registry, direct dependency links, current execution summary, and readiness.
Mark affected downstream milestone rows `revisiting` or the context `stale`
when assumptions are invalidated. Preserve historical decision IDs and link
superseded decisions instead of rewriting them.
