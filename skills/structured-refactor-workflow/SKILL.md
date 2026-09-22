---
name: structured-refactor-workflow
description: Orchestrate behavior-preserving structural refactors with pinned mature skills and a thin architecture acceptance overlay. Use for giant files or functions, god packages, module or layer migration, dependency inversion, transaction ownership, duplicated models, or refactors that must improve structure without changing behavior.
---

# Structured Refactor Workflow

Use mature installed skills for implementation. This skill only selects their order; `$safe-structured-refactor` is the single architecture acceptance source of truth.

## Ground rules

1. Follow repository instructions and architecture documents as the source of truth.
2. Choose one complete user-visible or business use case. Declare its entrypoint and terminal side effects; do not grade an internal helper as though it were the whole path.
3. Preserve behavior unless the user explicitly authorizes a change.
4. Keep the user as the lifecycle checkpoint. Do not build a persona tree or paraphrasing meta-agent.
5. Do not commit, push, merge, or deploy unless requested.

## Choose the mode

### Read-only audit

For review, acceptance, or diagnosis, do not run the implementation lifecycle. Use repository instructions, `$safe-structured-refactor`, `$api-and-interface-design`, and `$code-review-and-quality`. Add `$deprecation-and-migration` only when legacy removal is in scope.

Report the requested and achieved acceptance level, concrete blockers, verification actually run, and missing runtime evidence. Do not modify code.

### Implementation

Use the smallest sequence that covers the slice:

1. `$api-and-interface-design` for ownership and boundaries.
2. `$test-driven-development` to characterize behavior.
3. `$incremental-implementation` for one vertical slice.
4. `$safe-structured-refactor` for architecture acceptance.
5. `$code-review-and-quality`, then `$code-simplification`.

Add a capability only when its trigger is present:

| Need | Mature skill |
|---|---|
| Requirements are unclear | `$spec-driven-development` |
| More than one coherent slice is required | `$planning-and-task-breakdown` |
| Challenge a risky design before or during implementation | `$doubt-driven-development` |
| Diagnose unexpected failures | `$debugging-and-error-recovery` |
| Remove legacy paths and adapters | `$deprecation-and-migration` |
| Trust boundaries, auth, secrets, money, or sensitive data | `$security-and-hardening` |
| Profiling, latency, resource use, or a performance invariant | `$performance-optimization` |

## Required checkpoints

Before editing, record:

- the chosen use case, entrypoint, terminal side effects, exclusions, and observable invariants;
- current owner and intended owner of policy, orchestration, persistence, transport, and external effects;
- transaction, lock, idempotency, ordering, and retry behavior when relevant;
- the intended owner-specific test file or integration suite, including whether it already mixes unrelated use cases;
- requested acceptance level: Mechanical, Transitional, or Target.

Before structural edits, resolve ownership and dependency direction with `$api-and-interface-design`. Then apply every scope, ownership, transaction, adapter, test-environment, and acceptance rule from `$safe-structured-refactor`; do not restate or weaken them here.

During implementation:

- run the smallest useful tests after each coherent slice;
- for a changed transaction boundary, add a failure-path test that proves earlier writes roll back when a later persistence or effect step fails;
- preserve relative effect order and batching semantics unless the user authorizes a behavior change; replacing one bulk operation with per-item calls, or moving an event across later mutations, is a behavior change even when final rows match;
- stop and use debugging when evidence contradicts the plan.

When `$doubt-driven-development` is warranted, give the reviewer the raw artifact, behavioral contract, and relevant repository architecture source of truth. Do not encode the proposed design as the contract. The reviewer must be allowed to reject the scope, ownership, or dependency direction. Run one doubt cycle per material architecture decision; repeat only after an actionable finding materially changes the artifact.

Before completion:

- run repository-native format, build, test, lint, and dependency checks;
- run repository governance scripts and architecture scanners, then treat a newly triggered guard as design evidence: move the responsibility to an allowed owner or narrowly update the guard for the new intended owner; never disable or broadly bypass it;
- inspect the complete diff and all changed call sites;
- run architecture review and code simplification as separate passes;
- apply the complete `$safe-structured-refactor` acceptance checklist;
- report the acceptance path and level, remaining seams and removal conditions, verification actually run, missing deterministic evidence, and rollback path.

Stop when the declared slice meets its requested level or a concrete blocker is proven. Do not add another abstraction, audit pass, custom metric, or project-independent gate without new evidence that it prevents a real failure.

## Upstream maintenance

The composed skills are pinned and recorded in `references/upstream-skills.md`. After install or upgrade, or when drift is suspected, run:

```bash
scripts/verify-upstream-skills.sh
```

If verification fails, stop. Review and reinstall one coherent upstream revision; do not silently patch vendor copies.
