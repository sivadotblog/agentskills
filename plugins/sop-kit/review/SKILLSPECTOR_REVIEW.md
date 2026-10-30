# SkillSpector review: sop-kit

- **Scanner:** [NVIDIA SkillSpector](https://github.com/NVIDIA/skillspector) at commit `54921c8` (v2.12.0, installed from source)
- **Target:** sop-kit 0.2.0 (skills, agent, commands, template, example)
- **Mode:** static only (`--no-llm`). The optional LLM pass was not run.
- **Date:** 2026-10-30
- **Full report:** [skillspector-report.md](skillspector-report.md) (whole plugin, without this `review/` folder)

## Result

| Scope | Score | Severity | Findings |
|---|---|---|---|
| Whole plugin | 38 | MEDIUM | 3 |
| skills/sop-author | 0 | LOW | 0 |
| skills/sop-runner | 8 | LOW | 1 |
| examples | 30 | MEDIUM | 2 |

Overall: **38/100**, recommendation **CAUTION** (below the 50 "do not install" line). Coverage 100%.

**Verdict:** all 3 findings are false positives. The 2 real risks are design issues the scanner doesn't flag; see [Manual review](#manual-review-not-flagged-by-the-scanner).

## Resolution

Each false positive is accepted in a SkillSpector baseline under [baselines/](baselines/), with the reason recorded. Exact fingerprints are used, so any change to the file, or a SkillSpector upgrade, brings the finding back for another review. With the baselines applied, `review/scan.sh` reports **0/100 and 0 new findings** for every scope (3 suppressed).

## Findings

### 1. EA2 Autonomous Decision Making, MEDIUM: `skills/sop-runner/SKILL.md:14` (`never ask the user`)
> **No secrets in chat.** If an input is marked sensitive, never ask the user to type it. ...

**Assessment: false positive.** This is a safety rule: the agent must never collect secrets in chat, only check that they exist in Key Vault. It gives the agent less autonomy, not more.

### 2–3. E2 Env Variable Harvesting, HIGH: `examples/prefect-databricks-connection.md:14` and `:31` (`secret in Key`)
> - **secret_name**: Name for the secret in Key Vault? ...
>
> - Check: `az keyvault secret show ... --query id -o tsv` returns a URL ending in {{secret_name}}/...

**Assessment: false positive.** This is example SOP text, not code, and no environment variables are read. The Check on line 31 asks only for the secret's `id` (its URL), never its value.

## Manual review (not flagged by the scanner)

### M1. Agent steps run SOP commands without approval by default: `skills/sop-runner/SKILL.md:45`
For `Who: agent` steps the runner says what it will do in one line, then runs the command. It only waits for a "yes" when the step has `Approval needed: yes`. `sop-format.md:42` says high-risk SOPs must mark every changing step that way, but the runner doesn't check this. That makes an SOP file effectively code: a careless or tampered SOP can run changing commands without a yes.

**Suggestion:** in rule 1 (Check the SOP), refuse a `risk: high` SOP whose changing agent steps lack `Approval needed: yes`. When showing the step list before step 1, include each agent step's exact command.

### M2. User inputs are substituted into shell commands unquoted: `skills/sop-runner/SKILL.md:44`
`{{name}}` is replaced with the user's answer and the command is run. An answer containing shell syntax (for example, `repo_path` = `~/code; rm -rf ~`) would run as part of the command. Line 39 checks answers against the *example*, which is not a strict format.

**Suggestion:** quote substituted values in shell commands. Reject values containing shell metacharacters (`;`, `|`, `&`, `` ` ``, `$(`, newlines) unless the SOP gives an allowed pattern.

## Re-run
```
uv tool install git+https://github.com/NVIDIA/skillspector.git
plugins/sop-kit/review/scan.sh   # per-scope scan with baselines; exits 1 on any new finding
```
`scan.sh` scans each skill and the examples folder on their own (SkillSpector refuses `--baseline` on recursive scans). It skips this `review/` folder because it quotes the flagged text. After changing a flagged file, re-review any finding that comes back, then regenerate its baseline with `skillspector baseline <dir> --no-llm -o plugins/sop-kit/review/baselines/<name>.yaml` and write the reasons again.
