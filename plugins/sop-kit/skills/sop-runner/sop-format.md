# SOP format

An SOP is a Markdown file with a short header and five sections.

```markdown
---
id: short-name-with-dashes
title: What this SOP does
version: 1.0
owner: Team or person to contact when stuck
risk: low | medium | high
skills: [azure-cli, databricks]     # skills the runner loads first
---

## Inputs
- **name**: Question to ask. Example: `value`
- **name**: Question to ask. Allowed: dev, test, prod
- **name** (sensitive): Never ask for it. Say where the user puts it.

## Prerequisites
- Description. Check: `command` or question. Fix: what to do if it fails.

## Steps

### 1. Step title
- Who: agent | you
- Do: command, file change, or instructions for the person
- Check: `command` and what output means success, or a yes/no question
- Approval needed: yes          # optional, for changes to shared things

## Done when
- Check: `command` and expected result

## After you finish
How to use what was set up.
```

## Writing tips
- One step does one thing and has one Check.
- Prefer a command Check. Use a question only when nothing can be checked with a tool, like a portal screen.
- Use `{{name}}` to insert an input value. Never use it for a sensitive input.
- On high-risk SOPs, every agent step that changes something needs "Approval needed: yes".
