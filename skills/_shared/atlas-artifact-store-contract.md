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

## Source binding and commits

Every durable artifact MUST identify the code repository and exact code commit
SHA it used. Artifact creation updates only the artifact
repository: stage only the authored artifact and directly related index or
manifest update, then commit there. Do not stage, commit, or modify code
repository files as part of artifact creation.

If the artifact repository is dirty in unrelated paths, preserve those changes
and stop rather than making an ambiguous commit. Push behavior depends on the
user's Git credentials and repository policy; do not store credentials in
configuration or artifacts.
