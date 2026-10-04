# sop-kit

An agent that walks people through SOPs in Claude Code.

## What it does
1. Reads the SOP and checks it is complete.
2. Loads the skills the SOP lists (Azure CLI, Databricks, and so on).
3. Asks the user for every input up front.
4. Checks prerequisites.
5. Walks through each step. Does agent steps itself. Waits for the user on their steps.
6. Checks each step before moving on.
7. Tells the user what to do next.

No Python or extra installs. Just Claude Code.

## Install
```
/plugin marketplace add sivadotblog/agentskills
/plugin install sop-kit@sivadotblog
```

## Uninstall
```
/plugin uninstall sop-kit@sivadotblog
```

## Use
- Run an SOP: `/sop-run examples/prefect-databricks-connection.md`
- Write an SOP from a doc: `/sop-new <doc or description>`

## Contents
- `agents/sop-runner.md`: the agent (the doer)
- `skills/sop-runner/`: how to run an SOP, and the SOP format (the knowledge)
- `skills/sop-author/`: how to write an SOP from a runbook
- `templates/sop-template.md`: blank SOP
- `examples/`: sample SOP

## Notes
- Use `/sop-run`. It runs the agent in your main conversation so it can ask you questions. If Claude hands the SOP off to the agent in the background instead, it cannot wait for your answers.
- Rules like "never skip a step" are followed by the model but not enforced. For unattended runs later, add Claude Code hooks for hard limits.
- Add `sop-progress/` to `.gitignore`.
