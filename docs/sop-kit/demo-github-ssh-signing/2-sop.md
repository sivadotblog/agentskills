---
id: github-ssh-signing
title: Set up an SSH key for GitHub and sign your commits
version: 0.1
owner: sivadotblog
risk: low
skills: []
---

## Inputs
- **github_email**: Which email is verified on your GitHub account? Example: `you@example.com`
- **github_username**: What is your GitHub username? Example: `octocat`
- **throwaway_repo**: What should the throwaway test repo be called? Example: `signing-test`
- **clone_dir**: Which folder should the test repo be cloned into? Example: `~/code`
- **key_passphrase** (sensitive): Never ask for it. You type it only into the terminal prompt in steps 1 and 2.

## Prerequisites
- git 2.34 or newer. Check: `git --version` shows 2.34 or higher. Fix: update git. Older versions cannot sign with SSH keys.
- OpenSSH is installed. Check: `ssh -V` prints a version. Fix: install OpenSSH.
- You are on macOS. Check: `uname -s` prints `Darwin`. Fix: this SOP covers macOS only.
- You have a GitHub account with a verified email. Check: Ask "Can you sign in to github.com, and is {{github_email}} marked verified under Settings → Emails?" Fix: sign in or verify the email first.

## Steps

### 1. Make the key
- Who: you
- Do: First, if `~/.ssh/id_ed25519` already exists, do not overwrite it. Tell the runner, and you can reuse it. Otherwise type `! ssh-keygen -t ed25519 -C "{{github_email}}"` in the prompt. Press Enter to accept the default file location. When it asks, type a passphrase. Never put the passphrase in the chat, Slack, or a ticket.
- Check: `ssh-keygen -lf ~/.ssh/id_ed25519.pub` prints a line ending in `{{github_email}} (ED25519)`

### 2. Load the key into the agent and the macOS keychain
- Who: you
- Do: Type `! ssh-add --apple-use-keychain ~/.ssh/id_ed25519` and enter your passphrase when asked.
- Check: `ssh-add -l` lists the same fingerprint as step 1

### 3. Keep the key loaded after a restart
- Who: agent
- Do: Add this block to `~/.ssh/config`. Create the file if it does not exist, and leave existing entries alone.
  ```
  Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
  ```
- Check: `ssh -G github.com | grep -i identityfile` shows `~/.ssh/id_ed25519`
- Approval needed: yes

### 4. Copy the public key
- Who: agent
- Do: `pbcopy < ~/.ssh/id_ed25519.pub` (the `.pub` file only, never the private key)
- Check: `pbpaste | ssh-keygen -lf -` shows the same fingerprint as step 1

### 5. Add the key to GitHub as an Authentication key
- Who: you
- Do: On github.com go to **Settings → SSH and GPG keys → New SSH key**. Give it a title, set Key type to **Authentication Key**, paste the key (Cmd+V), and click **Add SSH key**.
- Check: Ask "Do you see the key listed under Authentication keys?"

### 6. Add the same key to GitHub as a Signing key
- Who: you
- Do: Click **New SSH key** again. Set Key type to **Signing Key**, paste the same key, and click **Add SSH key**. People often forget this one, and then their commits show Unverified.
- Check: Ask "Do you see the key listed under Signing keys?"

### 7. Test the connection
- Who: agent
- Do: `ssh -T git@github.com`. If it asks about the host fingerprint, stop and ask the person to type `! ssh -T git@github.com` and answer yes.
- Check: the output contains `Hi {{github_username}}! You've successfully authenticated` (exit code 1 is normal here)

### 8. Set your git email
- Who: agent
- Do: `git config --global user.email "{{github_email}}"`
- Check: `git config --global --get user.email` prints `{{github_email}}`
- Approval needed: yes

### 9. Tell git to sign with the key
- Who: agent
- Do:
  `git config --global gpg.format ssh`
  `git config --global user.signingkey ~/.ssh/id_ed25519.pub`
  `git config --global commit.gpgsign true`
- Check: `git config --global --get gpg.format` prints `ssh`, and `git config --global --get commit.gpgsign` prints `true`
- Approval needed: yes

### 10. Let git check signatures locally
- Who: agent
- Do:
  `mkdir -p ~/.config/git`
  `echo "{{github_email}} $(cat ~/.ssh/id_ed25519.pub)" > ~/.config/git/allowed_signers`
  `git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers`
- Check: `git config --global --get gpg.ssh.allowedSignersFile` prints the path, and that file starts with `{{github_email}}`
- Approval needed: yes

### 11. Make a throwaway repo on GitHub
- Who: you
- Do: On github.com click **New repository**. Name it `{{throwaway_repo}}`. Private is fine. Tick **Add a README** so it is not empty. Click **Create repository**.
- Check: `git ls-remote git@github.com:{{github_username}}/{{throwaway_repo}}.git` succeeds

### 12. Clone it
- Who: agent
- Do: `cd {{clone_dir}} && git clone git@github.com:{{github_username}}/{{throwaway_repo}}.git`
- Check: `git -C {{clone_dir}}/{{throwaway_repo}} remote -v` shows the SSH URL

### 13. Make a signed test commit
- Who: agent
- Do: In `{{clone_dir}}/{{throwaway_repo}}`: `echo "hello" > test.txt && git add test.txt && git commit -m "test signed commit"`
- Check: `git log --show-signature -1` contains `Good "git" signature`

### 14. Push the test commit
- Who: agent
- Do: `git push`
- Check: `git ls-remote origin HEAD` matches `git rev-parse HEAD`
- Approval needed: yes

### 15. Check the Verified badge
- Who: you
- Do: Open `https://github.com/{{github_username}}/{{throwaway_repo}}/commits` and look at the "test signed commit".
- Check: Ask "Does the commit show a green **Verified** badge?"

### 16. Delete the throwaway repo (optional)
- Who: you
- Do: On GitHub, open the repo, then **Settings → Danger Zone → Delete this repository**.
- Check: Ask "Is the repo deleted, or do you want to keep it?"

## Done when
- Check: `ssh -T git@github.com` says `Hi {{github_username}}! You've successfully authenticated`
- Check: `git config --global --get commit.gpgsign` prints `true`
- Check: the person confirms the test commit showed **Verified** on GitHub

## After you finish
You can now push to GitHub over SSH, and every commit you make is signed and shows **Verified**.

If something stops working:
- **Permission denied (publickey)**: the key isn't loaded (check with `ssh-add -l`), or it was added only as a Signing key, not an Authentication key.
- **Unverified on GitHub**: the email on the commit doesn't match a verified email on your account, or the Signing key wasn't added.
- **`error: unsupported value for gpg.format: ssh`**: your git is too old.

Ask sivadotblog if you're stuck.
