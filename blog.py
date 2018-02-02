import click
import datetime
import netrc
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

@click.command()
def links():
    """Gather latest links from theoldreader.com and put into a note."""
    new_links = get_links_from_old_reader()
    name = "links-{}".format(datetime.datetime.now().strftime("%Y%m%d%H%M%S"))
    call(["hugo", "new", f"notes/{name}.md", "-k", "links"])
    with click.open_file(f'content/notes/{name}.md', 'a+') as file:
        file.write("\n")
        for link in new_links:
            file.write("[{title}]({href})".format(**link))
            if link.get('note'):
                file.write(" {note}".format(**link))
            file.write("\n\n")
    click.launch(f'content/notes/{name}.md')

def get_links_from_old_reader():
    try:
        logins = netrc.netrc()
    except FileNotFoundError:
        click.echo("No .netrc file exists")
        exit(1)

    credentials = logins.authenticators('theoldreader.com')
    if credentials is None:
        click.echo("No credentials for theoldreader.com in .netrc")
        exit(1)

    import requests

    r = requests.post('https://theoldreader.com/accounts/ClientLogin', data={
        'client': 'YourAppName',
        'accountType': 'HOSTED_OR_GOOGLE',
        'service': 'reader',
        'Email': credentials[0],
        'Passwd': credentials[2],
        'output': 'json'
    })
    token = r.json()['Auth']

    def __auth(r):
        r.headers['Authorization'] = f"GoogleLogin auth={token}"
        return r

    r = requests.get('https://theoldreader.com/reader/api/0/stream/contents', params={
        'output': 'json',
        's': 'user/-/state/com.google/broadcast'
    }, auth=__auth)

    new_links = []

    for item in r.json()['items']:
        link = {
            'title': item['title'],
            'href': item['canonical'][0]['href']
        }
        if len(item['annotations']) > 0:
            link['note'] = item['annotations'][0].get('text')
        new_links.append(link)
    return new_links

cli.add_command(links)
