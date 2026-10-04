---
name: sop-author
description: Turn a runbook, wiki page, ADO or Confluence doc, README, or a plain description of a manual process into an SOP in the sop-kit format. Use whenever someone wants to write, convert, or improve an SOP, runbook, or checklist so the SOP runner can walk people through it.
---

# Writing an SOP

Format: `../sop-runner/sop-format.md`. Start from `templates/sop-template.md` in the plugin.

## Rules
1. **Never make things up.** If the source does not say it, write `TBD: <what is needed>`. No invented names, URLs, IDs, or commands.
2. **Draft, then stop.** Show the draft and a list of every TBD and assumption. Wait for the author to confirm or fix before you save the final version.
3. **One step, one action, one Check.** "Create the SPN, grant access, and store the secret" is three steps.
4. **Agent where possible.** If a tool can do or check a step (CLI, file edit, git), make it `Who: agent` with a command Check.
5. **Person for judgment, consoles, credentials, and sign-offs.** Those are `Who: you`.
6. **Secrets never pass through the agent.** The person stores them. The agent only checks they exist.
7. **Approval for shared changes.** Commits, deploys, infra, and access grants get "Approval needed: yes".

## Flow

```
SOP authoring progress:
- [ ] Read the source
- [ ] List inputs, prerequisites, steps
- [ ] Set Who and Check for each step
- [ ] List skills the runner will need
- [ ] Self-review against the checklist below
- [ ] Show draft and TBD list, stop for review
- [ ] Apply fixes and save
```

## Self-review checklist
Go through this before showing the draft. Fix what fails.
- Header has id, title, version, owner, risk, skills.
- Every input has a question. Sensitive inputs say where the value goes.
- Every `{{name}}` matches an input. No `{{name}}` for sensitive inputs.
- Every step has Who, Do, and Check.
- Steps marked `Who: you` have instructions a non-technical person can follow.
- Risky or shared changes have "Approval needed: yes".
- "Done when" and "After you finish" are filled in.
