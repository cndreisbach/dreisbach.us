---
title: "Recursively searching up directories"
subtitle: "Write scripts that look for a local config file"
date: 2014-11-30T10:43:15-04:00
draft: false
aliases:
  - /blog/recursively-searching-up-directories/
---

I found myself needing to search up the directory tree for a specific file recently, much like `git` does to find the `.git` directory above it or [rbenv][] does to find the `.ruby-version` file that will tell it which Ruby runtime to use. It wasn't as simple to figure out as I expected.

Here's the shell function I ended up with:

```sh
findup() {
    _path=$(pwd)
    while [[ "$_path" != "" ]]; do
        if [[ -e "$_path/$1" ]]; then
            echo "$_path/$1"
            return 0
        else
            _path=${_path%/*}
        fi
    done
    return 1
}
```

The first few lines of this should be pretty obvious: I'm defining a function, then setting a variable, `_path`, to the current working directory. Then I enter a loop as long as `_path` doesn't equal an empty string.

Next, in the `if` statement, I look to see if the file I'm looking for is in the current directory. If so, I print its location and exit with 0, which is the [exit status][] for success in Unix-based operating systems.

The `else` part of the `if` statement is the only tricky part about this little function. I'm using Bash [parameter substitution][]. When I use the `${var}` form to access a variable, I get its value back. I can add to this form to manipulate the return value. [Using the `${var%pattern}` form][var-pattern form], I remove from the end of `${var}` the shortest part that matches my pattern. My pattern in this case is `/*`, which is going to match everything from the last slash forward; in other words, it will remove the last part of `_path`, leaving me with the parent directory.

If I get to the root directory (`/`) and haven't found the file I'm looking for, I return 1 to let any program using this function that I exited unsuccessfully, in proper Unix fashion.

Drop that function in your `.bashrc` or `.zshrc` and you can use it too.

[rbenv]: https://github.com/sstephenson/rbenv
[exit status]: http://www.gnu.org/software/bash/manual/html_node/Exit-Status.html
[parameter substitution]: http://tldp.org/LDP/abs/html/parameter-substitution.html
[var-pattern form]: http://tldp.org/LDP/abs/html/parameter-substitution.html#PCTPATREF
