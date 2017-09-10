import click
from subprocess import call

@click.group()
def cli():
    pass

@click.command()
@click.argument('name')
def note(name):
    """Create a new note called NAME and open it in an editor."""
    call(["hugo", "new", "notes/{}.md".format(name)])
    click.launch('content/notes/{}.md'.format(name))

cli.add_command(note)