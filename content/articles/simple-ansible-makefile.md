---
title: "Simple Ansible Makefile"
date: 2016-02-28T10:45:02-04:00
draft: false
aliases:
  - /blog/simple-ansible-makefile/
---

I love using [Ansible][] for deploying projects these days, but I don't like typing the same long command over and over. It's usually something like this:

```sh
ansible-playbook -i hosts --vault-password-file=.vault-password.txt site.yml
```

It's simple to create a Makefile to automate this, but I wanted to go one further. For speed purposes, I like to run particular roles separately sometimes.

My new Makefile:

```Makefile
tags = $(subst roles/,,$(wildcard roles/*))
.PHONY: all $(tags)

all:
	ansible-playbook -i hosts --vault-password-file=.vault-password.txt site.yml

$(tags):
	ansible-playbook -i hosts -t $@ --vault-password-file=.vault-password.txt site.yml
```

Now I can run, for example, `make nginx` to just run the Nginx role. You can see this in action at my [homebase](https://github.com/cndreisbach/homebase/) repository.

[Ansible]: https://docs.ansible.com/ansible/index.html
