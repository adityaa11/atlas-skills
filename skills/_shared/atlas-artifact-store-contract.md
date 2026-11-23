# Atlas Artifact Store Contract

## Purpose

This contract gives Atlas skills one portable, Git-host-agnostic location for
durable project artifacts. It applies to Project Context, Stack Context,
Implementation Context, tickets, checkpoints, CK feedback, HMN
authorizations, and their indexes. It does not store reusable skill definitions
or source code.

Use the [Atlas Terminology](atlas-terminology.md) for all repository and
commit references in this contract and its consuming skills.

## Required resolution

Before reading or writing a durable artifact, a consuming skill MUST:

1. resolve the code repository root;
2. read its tracked `atlas-workflow.yaml`;
3. optionally read its ignored `atlas-workflow.local.yaml` for a local checkout
   path;
4. resolve the configured artifact checkout, normally mounted at `.atlas`;
5. verify it is a Git worktree whose `origin` matches `expected_remote`; and
6. verify `.atlas/atlas-artifacts.yaml` declares the supported
   `atlas-workflow` layout.

If any condition is missing, ambiguous, or invalid, stop before creating or
updating a durable artifact. Instruct the user to run
`atlas-skills validate-artifacts <code-repo>` and, if needed,
`atlas-skills mount-artifacts <code-repo>`. Never fall back to `.agents`, the
skills repository, a temporary directory, or an invented project path.

The contract uses local Git only and works with GitHub, GitLab, Bitbucket,
Gitea, Azure DevOps, and private Git servers. A Windows junction, Unix
symlink, or no mount at all is an access mechanism, not artifact authority.

## Canonical layout

```text
.atlas/
  atlas-artifacts.yaml
  contexts/
    index.md
    project.md
    stack.md
    implementation/
      index.md
  tickets/
  checkpoints/
  feedback/
  evidence/
```

Use relative links within the artifact repository. A Project Context owns the
context index; Stack and Implementation Context add only their own index
entries. GO and CFC write ticket/checkpoint records under `tickets/` and
`checkpoints/`. CK and HMN write durable decision records under `feedback/`.

## Immutable evidence references

A new checkpoint or review MAY reference an existing committed evidence object
in the same validated artifact repository instead of copying it to a new path.
A reference identifies the artifact-repository commit, path
at that commit, and Git blob SHA; a path or blob SHA alone is insufficient.
Record the code commit originally observed, the scenario/route or other subject,
viewport/environment when relevant, and what was observed. The new checkpoint
or review still identifies its own exact current code commit under the source
binding rule below. The consuming Review Contract decides whether that prior
observation is applicable to a current obligation.

Before relying on a reference, verify that the path resolves to the stated blob
at the stated artifact commit in the validated repository and that a reviewer
can retrieve it. A missing, ambiguous, changed, or inaccessible object is not
evidence: make a new observation or report the row unproven. Referencing an
object never changes its historical source binding, creates a new observation,
or excuses required validation. Do not overwrite, move, delete, or rewrite
historical evidence to consolidate references. A separate manifest or new
directory is not required; the existing checkpoint/review evidence ledger may
hold these locators.

## Source binding and commits

Every durable artifact MUST identify the code repository and exact code commit
SHA it used. Artifact creation updates only the artifact
repository: stage only the authored artifact and directly related index or
manifest update, then commit there. Do not stage, commit, or modify code
repository files as part of artifact creation.

Before writing, capture the artifact repository's Git status and keep an
explicit list of paths the current operation creates or changes. The index
MUST be clean before staging: a pre-existing staged entry is ambiguous and
requires stopping. Preserve pre-existing changes; never reset, stash, stage,
or commit them.

Tracked modifications, deletions, renames, or conflicts outside the current
operation's explicitly owned paths make the commit ambiguous: stop rather than
including, overwriting, or repairing them. Pre-existing untracked artifacts do
not by themselves make a ticket-set creation ambiguous. In that case the
ticket-set operation MAY continue only when it:

1. records the pre-write untracked-path inventory;
2. writes only its newly allocated ticket-set paths and directly related clean
   index or manifest updates;
3. stops before writing if a target path already exists in the pre-write
   inventory; and
4. stages and commits an explicit allowlist consisting solely of its authored
   paths and those directly related index or manifest updates.

In particular, an operation MUST NOT stage an existing untracked path merely
because it is under `tickets/`, `checkpoints/`, `feedback/`, or `evidence/`.
This exception does not authorize a mixed commit, nor does it apply when the
operation cannot determine ownership of every path it would stage. Push
behavior depends on the user's Git credentials and repository policy; do not
store credentials in configuration or artifacts.
