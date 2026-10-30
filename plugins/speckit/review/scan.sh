#!/usr/bin/env bash
# Re-run the SkillSpector review of the speckit skills (static mode).
# Recursive scans can't take a baseline, so each skill is scanned on its own,
# with its reviewed baseline when one exists. Exits non-zero on any new finding.
set -euo pipefail
cd "$(dirname "$0")/.."
status=0
out=$(mktemp)
trap 'rm -f "$out"' EXIT
for dir in skills/*/; do
  skill=$(basename "$dir")
  args=(scan "$dir" --no-llm --format json --output "$out")
  [[ -f "review/baselines/$skill.yaml" ]] && args+=(--baseline "review/baselines/$skill.yaml")
  : >"$out"  # a failed scan leaves this empty, so the parse below fails closed
  skillspector "${args[@]}" >/dev/null 2>&1 || true
  read -r score issues suppressed < <(python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["risk_assessment"]["score"], len(d["issues"]), d["suppressed_count"])' <"$out")
  printf '%-24s score=%-3s new=%-3s suppressed=%s\n' "$skill" "$score" "$issues" "$suppressed"
  [[ "$issues" == 0 ]] || status=1
done
exit $status
