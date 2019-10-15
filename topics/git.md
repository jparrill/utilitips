# Git Cheatsheet

## Force Sync a fork

```
git remote add upstream https://github.com/some_user/some_repo
git fetch upstream
git checkout master
git reset --hard upstream/master  
git push origin master --force
```

REF: https://gist.github.com/ravibhure/a7e0918ff4937c9ea1c456698dcd58aa

## Stash changes to apply in other branch

```
git stash
git checkout -b xxx
git stash pop
```

REF: https://stackoverflow.com/questions/6925099/git-stash-changes-apply-to-new-branch

## Get git changes from origin without push

```
git reset --hard origin/master
git pull --rebase origin master
git status
```
