# Pinned upstream skills

Source: `addyosmani/agent-skills`

Revision: `7829ffd90d973b6325f5f12f1b1226dcace74443`

License: MIT

Installed skills:

| Skill | SHA-256 of `SKILL.md` |
|---|---|
| `using-agent-skills` | `a5bf05293cfb67af9c5e21e14023d723d2ac8ca42912cef4cee29fbb07e67d64` |
| `spec-driven-development` | `af5b873414a8b45b96b0d30d5297400f55eb3a56425161a088e470c14260a1e5` |
| `planning-and-task-breakdown` | `1fd1c06f06042d60123ec7144fd7f16655993b6cbc152e76eb5fcdd1a4805a6c` |
| `api-and-interface-design` | `293db2903b41316a5109a1e0ce3e1740eeafae31735bc1f9143dafbfd1187363` |
| `test-driven-development` | `71fdddb96c2c54041fcfbfdaef3c172b202fb9240b609e658d9d82edbed6cad1` |
| `incremental-implementation` | `f3336e581a5247d9a6a58096f0015dbbfb7673a35e71aebd39491c55662a1906` |
| `doubt-driven-development` | `59aef769adeae40aad67a1d54474aaf914ea7ecdfc2a4752a54840a8d29f80de` |
| `debugging-and-error-recovery` | `67ce2c9442da0c5a6e3515617fc9c4003cfe232ef7c7210da342f40f508f9958` |
| `deprecation-and-migration` | `92d9846321fab624eded7ac55d19a7738cfd2321c2be2e35eb153dcacf7359de` |
| `code-review-and-quality` | `bec431b759ff389e47b8d2c9d74e1981ff93cf5f3c36b4a3b6a71a75c250be2c` |
| `code-simplification` | `f0c5ed754057eb0c1e027e2587f59de816651feb5e837242296c43ea21cf621d` |
| `security-and-hardening` | `266c60e073bc81651ad070a1427a93af4d062dc44470580eae31806b38561833` |
| `performance-optimization` | `64f4f4105b66d155f0a6654dd8d542a58329d282c4e07bc82881bb755230fb29` |

The workflow composes these installed copies; it does not duplicate or patch them. Upgrade deliberately: inspect upstream changes, reinstall the whole set at one exact revision, refresh hashes, validate, then forward-test. Never silently follow upstream `main`.

Codex resolves relative references from each installed `SKILL.md` directory, while upstream stores shared references at repository root. Compatibility copies are therefore pinned too:

| Installed reference | SHA-256 |
|---|---|
| `planning-and-task-breakdown/references/definition-of-done.md` | `d1c75d2ae65d2c7a9cd01f93fa8de63e00e75f2fe5d08be224d576157054dcee` |
| `incremental-implementation/references/definition-of-done.md` | `d1c75d2ae65d2c7a9cd01f93fa8de63e00e75f2fe5d08be224d576157054dcee` |
| `using-agent-skills/references/definition-of-done.md` | `d1c75d2ae65d2c7a9cd01f93fa8de63e00e75f2fe5d08be224d576157054dcee` |
| `doubt-driven-development/references/orchestration-patterns.md` | `61e543d86f19f86b83074f8c1c769455c7085a2c72dd47b1da21a8c63785be4a` |
| `security-and-hardening/references/security-checklist.md` | `a8bbff3b1ac9122985e98fbe9a8fa09cd8ad53b190bac7f8f0f63687900f7d7a` |
| `performance-optimization/references/performance-checklist.md` | `628539583b7f515f84d0b8e4f4210ccdc0449afd31901149a078209f0769e654` |
