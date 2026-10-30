#!/usr/bin/env bash
# Re-run the SkillSpector review of sop-kit (static mode).
# Scans each skill and the examples folder on their own (recursive scans can't
# take a baseline), with a reviewed baseline when one exists. The review folder
# itself is not scanned: it quotes the flagged text. Exits non-zero on any new finding.
set -euo pipefail
cd "$(dirname "$0")/.."
status=0
out=$(mktemp)
trap 'rm -f "$out"' EXIT
for dir in skills/*/ examples/; do
  name=$(basename "$dir")
  args=(scan "$dir" --no-llm --format json --output "$out")
  [[ -f "review/baselines/$name.yaml" ]] && args+=(--baseline "review/baselines/$name.yaml")
  : >"$out"  # a failed scan leaves this empty, so the parse below fails closed
  skillspector "${args[@]}" >/dev/null 2>&1 || true
  read -r score issues suppressed < <(python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["risk_assessment"]["score"], len(d["issues"]), d["suppressed_count"])' <"$out")
  printf '%-14s score=%-3s new=%-3s suppressed=%s\n' "$name" "$score" "$issues" "$suppressed"
  [[ "$issues" == 0 ]] || status=1
done
exit $status
