"""Run the README installer in isolation: python3 tests/test_installation.py."""

from pathlib import Path
import re
import shutil
import subprocess
import tempfile


def main():
    repo = Path(__file__).resolve().parents[1]
    script = re.search(r"```bash\n(.*?)\n```", (repo / "README.md").read_text(), re.S).group(1)
    with tempfile.TemporaryDirectory(prefix=".install-test-", dir=repo) as tmp:
        root = Path(tmp)
        source = root / "source"
        source.mkdir()
        shutil.copytree(repo / "skills", source / "skills")
        shutil.copyfile(repo / "dependencies.sha256", source / "dependencies.sha256")
        project = root / "project"
        # A quoted path with spaces exercises the documented shell quoting.
        project = project.with_name("project with spaces")
        command = script.replace("project_root=/absolute/path/to/project", f'project_root="{project}"')

        def install():
            return subprocess.run(["bash", "-c", command], cwd=source, capture_output=True, text=True)

        result = install()
        assert result.returncode == 0, result.stderr
        installed = project / ".codex/skills"
        expected = {p.relative_to(source / "skills"): p.read_bytes()
                    for p in (source / "skills").rglob("*") if p.is_file()}
        actual = {p.relative_to(installed): p.read_bytes()
                  for p in installed.rglob("*") if p.is_file()}
        assert actual == expected, "Fresh install is incomplete"
        assert install().returncode == 0, "Identical reinstall should succeed"

        changed = installed / "development-workflow/SKILL.md"
        changed.write_text("local customization\n")
        missing = installed / "code-review-workflow"
        shutil.rmtree(missing)
        assert install().returncode != 0, "Conflicting installed version must fail"
        assert changed.read_text() == "local customization\n", "Local edit was overwritten"
        assert not missing.exists(), "Conflict must be detected before any copying"

        shutil.rmtree(project)
        tampered = source / "skills/test-driven-development/SKILL.md"
        tampered.write_text(tampered.read_text() + "\nchanged dependency\n")
        assert install().returncode != 0, "Tampered dependency must fail verification"
        assert not project.exists(), "Source integrity failure must precede target writes"

    print("PASS: fresh install, identical reinstall, conflict protection, dependency tampering")


if __name__ == "__main__":
    main()
