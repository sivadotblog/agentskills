# Demo outcome: end-to-end sop-kit run

This is a transcript of the actual conversation for stages 2–4 of the sop-kit demo:
`/sop-kit:sop-new` turning `1-runbook.md` into `2-sop.md`, then `/sop-kit:sop-run`
walking through it. Dialogue and command output are kept as they happened;
internal tool/system scaffolding (schemas, reminders, skill listings) is left out
since it isn't part of the human-meaningful conversation. Sensitive values are
masked with asterisks.

One gap surfaced during the run and was left **unfixed on purpose**: the SOP
tells the person to run commands with the `!` prefix in steps 1, 2 and 7, but
that prefix can't answer an interactive prompt (a passphrase, a yes/no). All
three stalled until the person switched to a separate Terminal window. It's
kept here as-is so people can see what that actually looks like.

---

## Stage 2: `/sop-kit:sop-new`

**User:**

```text
/sop-kit:sop-new docs/sop-kit/demo-github-ssh-signing/1-runbook.md
```

**Claude:** read `1-runbook.md`, drafted an SOP in sop-kit format, and stopped with
a TBD list:

> 1. **Owner:** the source only says "ping the team channel." Who or what should
>    the SOP name as owner?
> 2. **Step 8, git email:** the source says "make sure your git email is set
>    right." Is `git config --global user.email "{{github_email}}"` the right
>    command, or should this only be a check?
> 3. **"Done when":** the source has no explicit section. I built it from the
>    source's step 5 ("Try it"). Confirm or change it.
> 4. **Linux:** the source mentions Linux in passing. I scoped this SOP to macOS
>    only (keychain, `pbcopy`). Is that OK, or should Linux be added?

plus a list of assumptions (risk: low, approval needed on steps 3/8/9/10/14,
steps 1–2 kept as `Who: you` since they need the passphrase, etc.).

**User:**

```text
owner sivadotblog, yes to step 8, rest looks fine
```

**Claude:** saved the SOP to `2-sop.md` with owner `sivadotblog` and step 8 set to
`git config --global user.email "{{github_email}}"`, and reported: 16 steps, 7 for
the person, 9 for the agent, 5 of those needing approval.

---

## Stage 3–4: `/sop-kit:sop-run`

**User:**

```text
/sop-kit:sop-run docs/sop-kit/demo-github-ssh-signing/2-sop.md
```

**Claude:** checked the SOP (passed), noted no skills were needed, and asked for
the four inputs (`github_email`, `github_username`, `throwaway_repo`,
`clone_dir`), reminding the user not to send the key passphrase in chat.

**User:**

```text
si********@gmail.com sivadotblog am goint to use a real repo https://github.com/sivadotblog/bioglow_fll  ~/code/temp
```

**Claude:** confirmed the inputs, flagged that a real (not throwaway) repo changes
three steps, and asked the user to choose:

> 1. **Step 11:** skip creating the repo, only run the Check.
> 2. **Steps 13–14:** (a) push to main as the SOP says, (b) push to a separate
>    branch instead, or (c) use a real throwaway repo.
> 3. **Step 16:** skip, since a real repo won't be deleted.

**User:**

```text
2 a) and confirmed
```

**Claude:** ran the prerequisite checks:

```text
git --version       → git version 2.46.0
ssh -V               → OpenSSH_9.9p2, LibreSSL 3.3.6
uname -s             → Darwin
```

All passed except the one question-based prerequisite, which it asked directly:
"Can you sign in to github.com, and is si********@gmail.com marked verified under
Settings → Emails?" It also noted no `~/.ssh/id_ed25519` existed yet, and that
`~/code/temp` didn't exist yet.

**User:**

```text
verified
```

**Claude:** showed the full 16-step list with who does each one, then gave step 1
instructions: run `ssh-keygen -t ed25519 -C "si********@gmail.com"` via the `!`
prefix, accept the default path, set a passphrase, never share it.

**User:**

```text
<bash-input> ssh-keygen -t ed25519 -C "si********@gmail.com"</bash-input>
<bash-stdout></bash-stdout>
<bash-stderr>Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/siva/.ssh/id_ed25519): </bash-stderr>
```

**Claude:** checked `~/.ssh/` and found no key had been created — the `!` prompt
isn't interactive, so `ssh-keygen` got no further input and the process stalled.
Flagged this as a gap in the SOP (not something the user did wrong), and asked
the user to re-run the same command in a separate Terminal window instead.

**User:**

```text
done
```

**Claude:** ran the check:

```text
ssh-keygen -lf ~/.ssh/id_ed25519.pub
→ 256 SHA256:**************************************** si********@gmail.com (ED25519)
```

Passed. Gave step 2: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`, in the same
separate Terminal.

**User:**

```text
done
```

**Claude:** checked `ssh-add -l` — same fingerprint, passed. Asked approval for
step 3 (create `~/.ssh/config` with a `Host github.com` block for
`AddKeysToAgent`/`UseKeychain`/`IdentityFile`).

**User:**

```text
ok
```

**Claude:** created the file, `chmod 600`, checked with
`ssh -G github.com | grep -i identityfile` → `identityfile ~/.ssh/id_ed25519`,
passed. Ran step 4 itself (`pbcopy < ~/.ssh/id_ed25519.pub`), checked the
clipboard fingerprint matched, passed. Gave step 5: add the key on
github.com/settings/ssh/new as an **Authentication Key**.

**User:**

```text
yes
```

**Claude:** step 5 passed. Gave step 6: add the same key again as a **Signing
Key**.

**User:**

```text
yes
```

**Claude:** step 6 passed. Gave step 7: run `ssh -T git@github.com` in the
separate Terminal, verify the host fingerprint
(`SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU`, GitHub's published one)
before typing yes.

**User:**

```text
done
```

**Claude:** ran the check itself:

```text
ssh -T git@github.com
→ Hi sivadotblog! You've successfully authenticated, but GitHub does not provide shell access.
```

Passed (exit code 1 is expected). Asked approval for steps 8–10 together: set
`user.email`, set SSH commit signing (`gpg.format`, `user.signingkey`,
`commit.gpgsign`), and write an allowed-signers file for local verification.
Noted no git identity was configured yet, so nothing would be overwritten, and
that `user.name` wasn't in the SOP at all.

**User:**

```text
user.name = sivadotblog yes to all
```

**Claude:** ran all three steps plus the extra `user.name` the user asked for:

```text
user.email = si********@gmail.com, user.name = sivadotblog
gpg.format = ssh, commit.gpgsign = true, user.signingkey = ~/.ssh/id_ed25519.pub
gpg.ssh.allowedSignersFile = ~/.config/git/allowed_signers
```

All three checks passed. Ran step 11's check itself (`git ls-remote` against the
real repo) — passed, repo reachable. Asked approval to create `~/code/temp` for
step 12.

**User:**

```text
ok
```

**Claude:** created the folder, cloned the repo, checked the remote and branch —
passed, nothing was overwritten (`test.txt` didn't already exist). Ran step 13
itself (wrote `test.txt`, committed):

```text
git log --show-signature -1
→ Good "git" signature for si********@gmail.com with ED25519 key SHA256:****...
```

Passed. Asked approval for step 14 (push to `main` on the real repo
`sivadotblog/bioglow_fll`), naming exactly what would be pushed.

**User:**

```text
yes
```

**Claude:** pushed, confirmed local and remote `HEAD` matched. Gave step 15: open
the commits page and check for the green **Verified** badge on the test commit.

**User:**

```text
yes
```

**Claude:** ran the three "Done when" checks (SSH auth, `commit.gpgsign`, and the
user's Verified confirmation) — all passed — and reported what to do next
(push over SSH from now on; troubleshooting tips for publickey/Unverified/old
git), then summarized the run: 9 of 16 steps done by the agent, 6 by the person,
1 skipped, 4 approvals asked, no passphrase ever seen in chat, and one real gap
found in the SOP (the `!` prompt isn't interactive, so steps 1, 2 and 7 needed a
separate terminal).
