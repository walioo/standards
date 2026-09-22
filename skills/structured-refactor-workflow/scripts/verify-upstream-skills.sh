#!/bin/sh
set -eu

skills_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)

verify() {
	name=$1
	expected=$2
	file="$skills_root/$name/SKILL.md"
	if [ ! -f "$file" ]; then
		echo "missing upstream skill: $name" >&2
		return 1
	fi
	actual=$(shasum -a 256 "$file" | awk '{print $1}')
	if [ "$actual" != "$expected" ]; then
		echo "upstream skill drift: $name expected=$expected actual=$actual" >&2
		return 1
	fi
	printf 'verified %s\n' "$name"
}

verify_reference() {
	file=$1
	expected=$2
	if [ ! -f "$file" ]; then
		echo "missing upstream reference: $file" >&2
		return 1
	fi
	actual=$(shasum -a 256 "$file" | awk '{print $1}')
	if [ "$actual" != "$expected" ]; then
		echo "upstream reference drift: $file expected=$expected actual=$actual" >&2
		return 1
	fi
	printf 'verified %s\n' "$file"
}

verify using-agent-skills a5bf05293cfb67af9c5e21e14023d723d2ac8ca42912cef4cee29fbb07e67d64
verify spec-driven-development af5b873414a8b45b96b0d30d5297400f55eb3a56425161a088e470c14260a1e5
verify planning-and-task-breakdown 1fd1c06f06042d60123ec7144fd7f16655993b6cbc152e76eb5fcdd1a4805a6c
verify api-and-interface-design 293db2903b41316a5109a1e0ce3e1740eeafae31735bc1f9143dafbfd1187363
verify incremental-implementation f3336e581a5247d9a6a58096f0015dbbfb7673a35e71aebd39491c55662a1906
verify test-driven-development 71fdddb96c2c54041fcfbfdaef3c172b202fb9240b609e658d9d82edbed6cad1
verify doubt-driven-development 59aef769adeae40aad67a1d54474aaf914ea7ecdfc2a4752a54840a8d29f80de
verify debugging-and-error-recovery 67ce2c9442da0c5a6e3515617fc9c4003cfe232ef7c7210da342f40f508f9958
verify deprecation-and-migration 92d9846321fab624eded7ac55d19a7738cfd2321c2be2e35eb153dcacf7359de
verify code-review-and-quality bec431b759ff389e47b8d2c9d74e1981ff93cf5f3c36b4a3b6a71a75c250be2c
verify code-simplification f0c5ed754057eb0c1e027e2587f59de816651feb5e837242296c43ea21cf621d
verify security-and-hardening 266c60e073bc81651ad070a1427a93af4d062dc44470580eae31806b38561833
verify performance-optimization 64f4f4105b66d155f0a6654dd8d542a58329d282c4e07bc82881bb755230fb29
verify_reference "$skills_root/planning-and-task-breakdown/references/definition-of-done.md" d1c75d2ae65d2c7a9cd01f93fa8de63e00e75f2fe5d08be224d576157054dcee
verify_reference "$skills_root/incremental-implementation/references/definition-of-done.md" d1c75d2ae65d2c7a9cd01f93fa8de63e00e75f2fe5d08be224d576157054dcee
verify_reference "$skills_root/using-agent-skills/references/definition-of-done.md" d1c75d2ae65d2c7a9cd01f93fa8de63e00e75f2fe5d08be224d576157054dcee
verify_reference "$skills_root/doubt-driven-development/references/orchestration-patterns.md" 61e543d86f19f86b83074f8c1c769455c7085a2c72dd47b1da21a8c63785be4a
verify_reference "$skills_root/security-and-hardening/references/security-checklist.md" a8bbff3b1ac9122985e98fbe9a8fa09cd8ad53b190bac7f8f0f63687900f7d7a
verify_reference "$skills_root/performance-optimization/references/performance-checklist.md" 628539583b7f515f84d0b8e4f4210ccdc0449afd31901149a078209f0769e654
