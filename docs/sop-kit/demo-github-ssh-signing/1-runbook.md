# Setting up SSH keys and signed commits for GitHub

*Last edited a while ago. Ping the team channel if something here is out of date.*

New laptop? Do this once so you can push to GitHub over SSH and so your commits show up as **Verified**. Takes about 10 minutes.

## Before you start

You need:
- A GitHub account (and you should know which email is the verified one on it)
- git 2.34 or newer (`git --version`). Older versions can't sign with SSH keys.
- OpenSSH (`ssh -V`). Already there on macOS and most Linux.

If you already have a key at `~/.ssh/id_ed25519`, you can probably reuse it and skip to adding it to GitHub. Don't overwrite it unless you know it isn't being used for anything else.

## 1. Make a key

```
ssh-keygen -t ed25519 -C "you@example.com"
```

Use your GitHub email. Press Enter to accept the default file location. It will ask for a passphrase. Use one. Don't put it in Slack, a ticket, or anywhere else, ever.

## 2. Load it into the agent

```
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

On Linux just drop the `--apple-use-keychain` bit.

On a Mac you'll also want this in `~/.ssh/config` so it survives a restart:

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

## 3. Put the public key on GitHub

Copy the **public** key (the `.pub` one, never the other file):

```
pbcopy < ~/.ssh/id_ed25519.pub
```

Then on github.com go to **Settings → SSH and GPG keys → New SSH key**.

You have to add it **twice**:
- once with Key type **Authentication Key**
- once with Key type **Signing Key**

People forget the second one all the time and then wonder why commits say Unverified.

Check the connection:

```
ssh -T git@github.com
```

You should get "Hi <username>! You've successfully authenticated". Say yes if it asks about the host fingerprint.

## 4. Tell git to sign with it

```
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

Make sure your git email is set right too.

So that `git log` can check signatures on your machine, add an allowed signers file:

```
mkdir -p ~/.config/git
echo "you@example.com $(cat ~/.ssh/id_ed25519.pub)" > ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

## 5. Try it

Make a throwaway repo on GitHub (private is fine), clone it over SSH, commit something, and push:

```
git clone git@github.com:<you>/<throwaway-repo>.git
cd <throwaway-repo>
echo "hello" > test.txt
git add test.txt
git commit -m "test signed commit"
git log --show-signature -1
git push
```

`git log --show-signature` should say `Good "git" signature`. Then open the commit on GitHub. It should have a green **Verified** badge.

You can delete the throwaway repo afterwards.

## If it doesn't work

- **Permission denied (publickey)**: the key isn't loaded (`ssh-add -l` to see), or you only added it as a Signing key and not an Authentication key.
- **Unverified on GitHub**: usually the email on the commit doesn't match a verified email on your GitHub account. Or you forgot to add the Signing key.
- **`error: unsupported value for gpg.format: ssh`**: your git is too old.
