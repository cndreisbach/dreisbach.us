---
title: "Better bash history"
date: 2014-12-07T00:00:00-04:00
draft: false
aliases:
  - /blog/better-bash-history/
---

When working in the terminal, I find it very useful to be able to quickly search through what I've done before. Often there's a command that you used that you can't quite remember. The default shell on most computers is `bash`, and you can customize it to help you search your history better. Here's the code from my bash configuration (in `~/.profile` or `~/.bash_profile` depending on your system):

```bash
# Append to history file instead of overwriting it.
shopt -s histappend

# Ignore duplicates in history, lines that start with a space, and some
# common commands.
export HISTCONTROL="ignoreboth"
export HISTIGNORE="exit:quit:bg:fg:ls:history"

# Allow for a large amount of commands to be stored in history instead
# of truncating early.
export HISTFILESIZE=50000
export HISTSIZE=10000

# Display the date and time of commands in history.
export HISTTIMEFORMAT='%F %T '

alias \?="history | grep $1"
alias top10="history | awk '{print \$4}' | sort | uniq -c | sort -rn | head -10"
```

By default, every time you save your terminal history, it will overwrite the previous history. We prevent that with the first line.

Ignoring duplicates in history probably makes sense, but why ignore lines that start with a space? I like that so that if I need to enter a password on the command line, I can have history ignore it easily.

The two aliases give me short commands to work with my history. The first, which is just a question mark, lets me search through my history. I write something like:

```bash
? git
```

and I'll see all the commands I ever used starting with `git`. I really like how this combines with adding the date and time to history, so I can search by day or hour as well.

The last alias is just a little fun. It'll show you the top 10 commands you use in the terminal. In the process of writing this blog post, I managed to erase my history file, so mine's pretty short and obvious:

```
$ top10
     15 history
      5 ls
      3 top10
      3 gst
      3 gap
      2 git
      2 gc
      2 echo
      2 alias
      2 ?
```
