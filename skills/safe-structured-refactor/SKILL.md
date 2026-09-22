---
name: safe-structured-refactor
description: Add a thin architecture ownership and acceptance overlay to a mature refactor workflow. Use when auditing layer boundaries, module ownership, transactions, adapters, duplicated models, dependency direction, or whether a refactor reached its claimed structural target.
---

# Safe Structured Refactor

This is an architecture overlay, not an implementation methodology. Use repository architecture documents first, `$api-and-interface-design` for boundary design, `$deprecation-and-migration` for legacy removal, and `$code-review-and-quality` for review.

## Acceptance levels

- **Mechanical**: code moved or functions split; behavior is preserved, but ownership and dependencies are materially unchanged.
- **Transitional**: a complete use case has a new owner; remaining legacy access is one-way, counted, and has a removal condition.
- **Target**: the use case is owned by the intended module, dependency direction is clean, duplicate execution paths are removed, and no migration adapter remains.

Never report Target when an adapter, duplicate model, reverse dependency, or legacy execution path remains.

Acceptance is monotonic: a slice cannot earn a higher level by improving local readability while reinforcing a wrong owner elsewhere on the same path. New policy or effects added to a known wrong owner cap the slice at Mechanical. A complete new owner with counted one-way legacy seams may be Transitional. Only a clean end-to-end path may be Target.

## Acceptance scope

Name the full path being graded as `entrypoint -> owners -> terminal effects`, including synchronous writes, outbox/events, and required worker or adapter callers. Attach the acceptance level to that path, not to a file, helper, or package. An excluded critical-path owner prevents Target.

## Ownership audit

For the chosen use case, identify before and after owners for:

- transport and request/response mapping;
- business policy and use-case orchestration;
- persistence queries, records, and transactions;
- external effects and infrastructure integrations;
- public boundary types and errors.

Reject structures where lower layers import service or transport types, persistence decides business policy, transport owns transactions, or two full models represent the same persisted entity.

Treat business-semantic identifiers as policy: business/status values, audit actions, event names, idempotency prefixes, and user-facing copy must be supplied by the domain/application owner. Persistence owns table/column names, database conflict behavior, and serialization mechanics. A repository that originates business-semantic identifiers has absorbed policy and fails the ownership gate.

Do not move presentation text, transport shapes, or infrastructure event keys into a pure domain package merely to reverse an import. Keep domain decisions separate from application mapping and persistence mechanics unless the repository architecture explicitly defines those values as domain contracts.

Apply wrong-side zero growth to every changed artifact. Code in a known legacy or wrong owner may only be deleted, reduced to one-way delegation, or minimally adapted for compatibility. Reject a refactor that adds new decisions, protocol values, persistence coordination, or terminal effects there, even when the new code is typed, tested, or shorter.

Record every dependency edge added and removed. Classify each new edge against the repository architecture source of truth; removing one reverse edge does not make the design clean when a forbidden sibling or lower-layer orchestration edge remains. Prefer repository-native and language-native dependency tools over custom parsers.

Do not introduce an interface, factory, or configuration layer merely to make the diagram look layered. Use a concrete dependency when there is one implementation and no required substitution seam. When an interface is justified by real implementations or focused testing, keep it consumer-owned and no wider than its callers require.

For transactional flows, preserve and verify transaction scope, lock order, idempotency/conflict behavior, write atomicity, effect ordering, batching/cardinality, retry, and replay semantics. First extract the old ordered trace (`lock/read -> mutations -> notices/events -> commit`) and its bulk groups; compare the final trace rather than only the final rows. Target requires negative tests covering each distinct terminal outcome against every independently failing effect class after an earlier mutation, unless existing tests demonstrably exercise the same transaction boundary.

Treat repository governance scripts and architecture scanners as part of the architecture contract. When moving an intended owner triggers a guard, either move the responsibility to an already allowed owner or narrowly update the guard to name the new intended owner. Reject broad allowlists, disabled checks, and path exceptions that do not correspond to an explicit ownership move.

Audit test ownership with production ownership. Prefer tests beside the policy or use case plus the smallest end-to-end acceptance test. For every changed test file, inspect total size, unrelated scenario breadth, and new wrong-side growth. Adding cases to a known giant test file is acceptable only when no focused harness exists; record the extraction condition and cap the slice at Transitional until the changed test path has a clear owner.

Audit the test environment as part of acceptance. Focused integration evidence must cross the real production seam. Broad integration evidence is comparable only when schema, database reset, fixture uniqueness, cache/external state, and isolation are controlled. If a broad shared-state run fails, reproduce the relevant failure alone in a clean environment before assigning causality. Report an unavailable deterministic broad gate explicitly; when that gate is mandatory, cap the slice below Target.

## Architecture acceptance

Accept the claimed level only when repository-native evidence shows:

- one complete vertical use case, not a collection of extracted helpers;
- dependency direction matches the repository plan;
- any justified interface is consumer-owned and no wider than its real callers require;
- every temporary adapter is one-way, has a real production caller, is covered through the seam, and names a concrete removal condition;
- legacy code is deleted at Target;
- focused behavior tests and full applicable checks pass;
- the final diff reduces concepts and change locality, not only file length.

A code-review approval means the change improves the codebase and may be mergeable. It does not upgrade the architecture level; grade Mechanical, Transitional, or Target independently.

If the user requests a numeric score, assign the acceptance level first, then score within its ceiling: Mechanical at most 6/10, Transitional at most 8/10, and only Target may exceed 8/10. Explain the concrete boundary that sets the ceiling; do not average passing tests into a higher architecture score.

Use ordinary repository searches, compiler/linter output, tests, Git diff, and the mature review skills as evidence. Apart from the requested score ceiling above, do not invent an evidence JSON, project-independent metric system, or language parser.
