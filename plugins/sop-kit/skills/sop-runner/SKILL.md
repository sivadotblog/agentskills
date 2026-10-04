---
name: sop-runner
description: How to read and run an SOP written in the sop-kit format. Covers checking the SOP is complete, collecting inputs, checking prerequisites, running agent and human steps, verifying each step, and finishing. Use whenever running, following, or resuming an SOP, runbook, or setup guide.
---

# Running an SOP

SOPs are Markdown files. The format is in `sop-format.md` next to this file. Read it before your first run.

## Rules

1. **Check the SOP first.** Before anything else, confirm the SOP has inputs, steps, a "Who" and a "Check" for every step, and a "Done when" section. If something is missing, tell the user what is missing and stop. Do not guess the missing parts.
2. **Never make things up.** Only use values the user gave you or that come from a tool result. If a value is missing, ask for it.
3. **No secrets in chat.** If an input is marked sensitive, never ask the user to type it. Follow the SOP's instructions for where they put it (Key Vault, for example). You may check that it exists. You never read or show its value.
4. **Check, don't trust.** A step is done when its Check passes. If the Check is a command, run it. If the Check is a question, ask it and get a clear yes.
5. **Two tries per step.** If a step's Check fails twice, stop and tell the user to contact the SOP owner. Do not keep trying.
6. **Approval before change.** If a step says "Approval needed: yes", show exactly what you will run or change, then wait for a clear yes.
7. **In order.** Never start a step before the one before it is checked and done.

## Flow

Start your first reply with this checklist and update it as you go:

```
SOP progress:
- [ ] Check the SOP
- [ ] Load skills
- [ ] Collect inputs
- [ ] Check prerequisites
- [ ] Steps
- [ ] Final check
- [ ] What to do next
```

**1. Check the SOP.** Read the whole file. Apply rule 1.

**2. Load skills.** Load each skill in the SOP's `skills:` list. If one is not installed, tell the user and ask whether to continue without it.

**3. Collect inputs.** Ask for every non-sensitive input in one message, using the question and example from the SOP. Check each answer against its example or allowed values. Repeat the full list back and ask the user to confirm.

**4. Check prerequisites.** Run each prerequisite's Check. If one fails, show its Fix and wait for the user before trying again.

**5. Steps.** Before the first step, show the full step list with who does each one. Then for each step:
- Replace `{{name}}` with the confirmed input values.
- **Who: agent.** Say what you will do in one line. Ask first if approval is needed. Do it. Run the Check.
- **Who: you.** Give the instructions exactly, with values filled in. Wait for the user to say done. Run the Check.
- After the Check passes, show the updated list with the step ticked.

**6. Final check.** Run every check in "Done when". All must pass.

**7. What to do next.** Show the "After you finish" section with values filled in.

## Saving progress

After each step, write the current checklist and confirmed inputs (never secrets) to `sop-progress/<sop-id>.md` in the working folder. If that file exists when a run starts, ask the user whether to continue from where they left off.
