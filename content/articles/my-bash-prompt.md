---
title: "My bash prompt"
date: 2013-10-29T09:31:05-04:00
draft: false
aliases:
  - /blog/my-bash-prompt/
---

My prompt has expanded and contracted over the years. When developing more in Ruby and Python, I found it very important to keep my current language versions in the prompt, but these days it's more important to me that my prompt works on every Unix-based machine I might log on to.

I keep my prompt setup in a file called [`prompt.sh`][prompt.sh], of course.

Here's what my prompt looks like after running a command for 10 seconds that resulted in an error:

![prompt screenshot](/img/my-bash-prompt/prompt.png)

On the first line, I have my current directory then my current Git branch, if I'm in a Git repository. Note the asterisk beside the Git branch: that means that I have uncommitted changes. Next, I have the amount of time the previous command took. This only shows up if the amount of time it took was 5 or more seconds; below that, it's not that important to know. Lastly, I have the exit status of the last command. I only show this if the exit status is not zero; that is, if there was an error.

To get the Git branch and the change status, I have these two functions:

```sh
function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != *"nothing to commit"* ]] && echo "*"
}

function parse_git_branch() {
  local git_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/")
  [[ -z $git_branch ]] || echo " $git_branch"
}
```

This is all pretty simple stuff. To get the branch, I run `git branch` and then use `sed` to get the line that starts with `*` and strip the `*` out. I append an asterisk to that if I know the repo is dirty (that is, there are uncommitted changes.) What's interesting here is that I pipe `STDOUT` to `/dev/null` in both these cases, and count on failure -- which will only happen if I'm not in a Git repo -- to produce no text. There is no test to see if I'm in a repo: I just go ahead and try it and print nothing on error.

The timer code is way more interesting:

```sh
function timer_start() {
  timer=${timer:-$SECONDS}
}

function timer_stop() {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

function prompt_command() {
  # ...
  timer_stop
  #...
}

PROMPT_COMMAND=prompt_command

trap timer_start DEBUG
```

`SECONDS` increases monotonically like you'd expect: add 1 every second. `trap timer_start DEBUG` is a neat piece of code. `trap` means "run the following function on the following signal," and the signal `DEBUG` is triggered every time a command is run. So, every time a command is run, `timer_start` is run. `timer_start` sets `timer` to `$SECONDS` if it's not currently set. The function assigned to `PROMPT_COMMAND`, which is called `prompt_command` in this case, is run every time the prompt is printed. Inside `prompt_command`, I execute `timer_stop`, which sets the variable `timer_show` equal to the timer subtracted from the current value of `SECONDS`. I can use `timer_show`, which has the calculated value of the amount of time it took to run the last command, when displaying the prompt.

The rest of what I do, printing error codes and setting colors, is all simple stuff that you can pick up from reading the file.

When I first set up my current prompt, I colored the `$` character on the second line of my prompt. It looked nice, but I found that the characters printed to set the color, normally invisible, sometimes caused the command at the prompt to shift to the right when scrolling up through history.

[prompt.sh]: https://github.com/cndreisbach/dotfiles/blob/0a48d153fe536a25b7970f654d773b0efeebb158/default/.bash/prompt.sh
