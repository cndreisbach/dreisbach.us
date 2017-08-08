---
title: "A favorite development tool: direnv"
date: 2017-01-03T00:00:00-04:00
draft: false
aliases:
  - /blog/a-favorite-development-tool-direnv/
---

[direnv](https://direnv.net/) has been the most useful tool in my software development repository in the last two years. It's a simple tool: it loads and unloads environment variables when you move into or out of a directory. It's fast, extensible, and never screws up, which makes it a rarity.

<!--more-->

You set direnv up by dropping an `.envrc` file wherever you want to use it. Let's look at one:

```bash
layout python /usr/local/bin/python3

PATH_add ./backend/django
export PYTHONPATH=./backend/django
export DJANGO_SETTINGS_MODULE=config.settings
export DATABASE_URL=postgresql://user@127.0.0.1:5432/projectdb
export SECRET_KEY=BADSECRETKEY
export DEBUG=True
```

That first line is killer. It tells direnv to create a [virtualenv](http://docs.python-guide.org/en/latest/dev/virtualenvs/) linked to the Python executable at `/usr/local/bin/python3` and then set up the environment variables to activate that virtualenv. When I leave the directory, the environment variables are unset. Similar commands exist for Go, Node, Ruby, and Perl, and it's not hard to write your own.

The second line uses a command `PATH_add` instead of a simple `export` statement. This prepends that directory to my `PATH`. The reasoning for a special command is to avoid  overwriting the `PATH`.

The `export` commands set environment variables I need for this application, which is a Django app. I use [django-environ](https://django-environ.readthedocs.io/en/latest/) with all my Django applications to make it easy to configure via environment variables.

---

The best thing about direnv is that it's extensible. You can add bash functions in a `~/.direnvrc` file and they are available to use in `.envrc` files. I have this one I took from [a comment on GitHub](https://github.com/direnv/direnv/issues/73#issuecomment-174295790):

```bash
# Example: export_alias zz "ls -la"
export_alias() {
  local name=$1
  shift
  local alias_dir=$PWD/.direnv/aliases
  local target="$alias_dir/$name"
  mkdir -p "$alias_dir"
  PATH_add "$alias_dir"
  echo "#!/usr/bin/env bash -e" > "$target"
  echo "$@" >> "$target"
  chmod +x "$target"
}
```

I'm not going to explain every line of bash code here, and if you do read and understand it, you'll see how it is an ugly hack, but it does allow me to do this in an `.envrc` file:

```bash
export_alias up "docker-compose up \$@ -d"
export_alias down "docker-compose down \$@"
export_alias manage "docker-compose run --rm backend ./manage.py \$@"
export_alias runtests "docker-compose run --rm backend py.test \$@"
export_alias backend "docker-compose run --rm backend bash \$@"
export_alias frontend "docker-compose run --rm frontend bash \$@"
```

This has been great for working with Docker. Typing those same commands over and over was not fun.

---

The small, simple tools I've seen written in Go have impressed me. direnv, [ghq](https://github.com/motemen/ghq), [peco](https://github.com/peco/peco), and [devd](https://github.com/cortesi/devd) are the ones I have used the most often.

I hope you give direnv a try! It has replaced a lot of other tools like pyenv and virtualenv for me.
