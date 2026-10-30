# speckit

[GitHub Spec Kit](https://github.com/github/spec-kit)'s spec-driven development skills for Claude Code, packaged as a plugin and security-reviewed with [NVIDIA SkillSpector](https://github.com/NVIDIA/skillspector).

## What it does
Takes a feature from idea to code in steps:
1. `/speckit-constitution`: set the project's principles.
2. `/speckit-specify <feature>`: write the feature spec.
3. `/speckit-clarify` (optional): ask questions to remove ambiguity.
4. `/speckit-plan`: write the technical plan.
5. `/speckit-checklist` (optional): check the requirements for quality.
6. `/speckit-tasks`: break the plan into tasks.
7. `/speckit-analyze` (optional): check spec, plan and tasks agree.
8. `/speckit-implement`: build it, task by task.

Also: `/speckit-converge` and `/speckit-taskstoissues` (turns tasks into GitHub issues; deprecated upstream).

## Requirements
The skills expect a Spec Kit project (a `.specify/` folder with scripts and templates). Set one up once per repo:
```
uvx --from git+https://github.com/github/spec-kit.git specify init --here --integration claude
```

## Install
```
/plugin marketplace add sivadotblog/agentskills
/plugin install speckit@sivadotblog
```

## Uninstall
```
/plugin uninstall speckit@sivadotblog
```

## Security review
Scanned with SkillSpector (static mode). Max risk score 28/100 (MEDIUM, "CAUTION"). We reviewed all 5 findings and found them to be false positives. Details: [review/SKILLSPECTOR_REVIEW.md](review/SKILLSPECTOR_REVIEW.md).

## Contents
- `skills/speckit-*/`: the 10 skills, copied unchanged from Spec Kit
- `review/`: the SkillSpector review and the full scan report
- `LICENSE-spec-kit`: Spec Kit's MIT license (the skills are © GitHub, Inc.)

## Source
Generated with `specify init --integration claude` from [github/spec-kit](https://github.com/github/spec-kit) at commit `2a23a84` (`specify` 1.2.6.dev0). To update, re-run that command and copy `.claude/skills/speckit-*` here.
