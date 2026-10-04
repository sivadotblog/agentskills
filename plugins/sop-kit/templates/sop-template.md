---
id: replace-me
title: Replace me
version: 0.1
owner: TBD
risk: low
skills: []
---

## Inputs
- **environment**: Which environment? Allowed: dev, test, prod
- **example_secret** (sensitive): Never ask for it. The user adds it to Key Vault in step 1.

## Prerequisites
- Azure CLI is logged in. Check: `az account show`. Fix: run `az login`.

## Steps

### 1. Example step for the person
- Who: you
- Do: Exact instructions for the person.
- Check: Ask "Do you see X?"

### 2. Example step for the agent
- Who: agent
- Do: `echo {{environment}}`
- Check: `echo ok` prints ok

## Done when
- Check: `echo ok` prints ok

## After you finish
How to use what was set up.
