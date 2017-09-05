#!/usr/bin/env python3

import click
from subprocess import call


@click.command()
@click.argument('name')
def note(name):
    call(["hugo", "new", "notes/{}.md".format(name)])
    click.launch('content/notes/{}.md'.format(name))

if __name__ == '__main__':
    note()
