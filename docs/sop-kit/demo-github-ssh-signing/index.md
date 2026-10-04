# Demo: GitHub SSH signing, end to end

This walks through sop-kit from a plain wiki page to a finished, checked run,
using a real scenario: setting up an SSH key for GitHub and turning on signed
commits.

## The four stages

1. **Draft a runbook.** [`1-runbook.md`](1-runbook.md) is written like a real
   team wiki page: loose prose, a couple of gaps, one vague step. Nothing in
   sop-kit format yet.
2. **Turn it into an SOP.** `/sop-kit:sop-new 1-runbook.md` read the runbook,
   split it into inputs, prerequisites, and 16 steps each with a `Who` and a
   `Check`, and stopped to ask about the gaps it found — no owner, and a step
   with no concrete command. [`2-sop.md`](2-sop.md) is the result, after those
   were answered.
3. **Run it.** `/sop-kit:sop-run 2-sop.md` walked through the SOP: it asked for
   every input up front, ran the agent steps itself, asked approval before
   changing git config or pushing, and waited for the person at the steps only
   they could do (typing a passphrase, using the GitHub web UI, confirming the
   **Verified** badge).
4. **See what happened.** [`outcome.md`](outcome.md) is the actual transcript
   of stages 2 and 3, as they happened, with the email address and key
   fingerprint masked.

## Who did what

|              | Count          | Examples                                                                                           |
| ------------ | -------------- | --------------------------------------------------------------------------------------------------- |
| Agent did it | 9 of 16 steps  | wrote `~/.ssh/config`, set git config, cloned, committed, pushed, ran every command-based Check     |
| Person did it | 6 of 16 steps | made the key, loaded it into the keychain, added it to GitHub twice, confirmed the Verified badge   |
| Skipped      | 1 step         | deleting the repo — this run used a real repo, not a throwaway one                                  |
| Approvals asked | 4 times     | before writing `~/.ssh/config`, before changing global git config (3 steps), before pushing         |

The passphrase for the SSH key was never typed into the chat at any point.

## A gap, left in on purpose

Steps 1, 2 and 7 tell the person to run a command with the `!` prefix. That
prefix sends the command straight to the shell, but it can't answer a prompt —
and `ssh-keygen` (for the passphrase) and `ssh -T git@github.com` (for the host
key) both ask one. All three stalled until the person ran the same command in
a separate terminal window instead.

This is a real limit of running interactive commands in Claude Code, not a bug
sop-kit introduced, and it's worth seeing: `outcome.md` shows the agent noticing
the stall, explaining it, and asking for the workaround rather than guessing or
retrying blindly.

## Try it yourself

```text
/plugin marketplace add sivadotblog/agentskills
/plugin install sop-kit@sivadotblog
/sop-kit:sop-new docs/sop-kit/demo-github-ssh-signing/1-runbook.md
/sop-kit:sop-run docs/sop-kit/demo-github-ssh-signing/2-sop.md
```
