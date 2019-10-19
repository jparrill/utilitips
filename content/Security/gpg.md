+++
title = "GPG Cheatsheet"
weight = 1
+++

- List keys

```
gpg --list-keys --keyid-format LONG
```

- Export Priv Key to file

```
gpg --export-secret-keys BA202938CB1C0C1E251F966ADE30627E53AC3969 > XXXXXX_priv.asc
```

- Decrypt gpg encrypted file

```
gpg -d ./XXXXXXX.gpg
```

- Encrypt gpg encrypted file

```
gpg -c virsh.md
```

- Export public Key

```
gpg --export --armor --output jparrill_redhat.asc jparrill@redhat.com
```

- Generate Key

```
gpg --full-gen-key
```

- Save all old things:
```
zip -er old_gpg.zip old_gpg
```

- Export GPG from one PC to other: https://makandracards.com/makandra/37763-gpg-extract-private-key-and-import-on-different-machine
```
Identify your private key by running gpg --list-secret-keys. You need the ID of your private key (second column)

Run this command to export your key: gpg --export-secret-keys $ID > my-private-key.asc

Copy the key to the other machine (scp is your friend)

To import the key, run gpg --import my-private-key.asc

If the key already existed on the second machine, the import will fail saying 'Key already known'. You will have to delete both the private and public key first (gpg --delete-keys and gpg --delete-secret-keys)
```

- Save all old things:
```
zip -er old_gpg.zip old_gpg
```

- Generate full Key
```
gpg --full-gen-key
```

- Export Public Key from ID
```
gpg --export --armor --output jparrill_redhat.asc jparrill@redhat.com
```

- List Keys
```
gpg --list-secret-keys --keyid-format LONG
```

- Export Secret from ID
```
gpg --export-secret-keys BA202938CB1C0C1E251F966ADE30627E53AC3969 > jparrill_redhat_priv.asc
```

- Configure Git to sign commits
```
# You could check the signing key listing the keys with long format
git config --global user.signingkey 9D253FF3D56812CA
git config --global commit.gpgsign true
git config --global gpg.program gpg
```

# pass - Password Manager Unix

- References: https://git.zx2c4.com/password-store/about/

## Quickstart

```
gpg --list-keys (get the ID)
```

```
pub   rsa4096/DE30627E53AC3969 2019-07-30 [SC]
      BA202938CB1C0C1E251F966ADE30627E53AC3969       <----- THIS ONE
uid                 [ultimate] Juan Manuel Parrilla Madrid (Red Hat Key for daily basis) <jparrill@redhat.com>
sub   rsa4096/7A3E889C6FE921D0 2019-07-30 [E]
```

Now create a new storage for it

```
pass init BA202938CB1C0C1E251F966ADE30627E53AC3969
pass insert RedHat/kerberos
```

# Git

- Configure Git to sign commits
```
# You could check the signing key listing the keys with long format
git config --global user.signingkey 9D253FF3D56812CA
git config --global commit.gpgsign true
git config --global gpg.program gpg
```


