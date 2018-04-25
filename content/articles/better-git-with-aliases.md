---
title: "Make git friendlier with aliases"
date: 2018-04-25T14:02:59-04:00
draft: false
---

Git drives me crazy with its obtuse command-line interface. Over time, I've added many aliases to my `~/.gitconfig` in order to make its interface more clear.

<!--more-->

Here are some of my favorites:

```
aliases = config --get-regexp ^alias\\.
discard = checkout --
generate-ignore = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi"
list-tracked = ls-tree -r HEAD --name-only
list-ignored = ls-files --others -i --exclude-standard
new-branch = checkout -b
push-branch = "!git push -u origin `git rev-parse --abbrev-ref HEAD`"
uncommit = reset --mixed HEAD~
unstage = reset -q HEAD --
```

`aliases` lists all my aliases. It could be formatted a bit better, but works well for me.

`discard` lets me discard changes to a file I'm working on. I never remember how to do this, especially as it uses the same command you use to switch branches.

`generate-ignore` can generate a `.gitignore` file for me. This isn't really making git easier, but I use it a lot.

`new-branch` and `push-branch` are huge for me. `new-branch` makes it explicit that I'm trying to create a new one, and `push-branch` pushes my local branch to a (generally new) branch of the same name on my origin repo.

`uncommit` and `unstage` are quick ways to reverse a mistake I've made without having to search for those arcane commands.
