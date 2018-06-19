import os
import testinfra


def test_service_is_running_and_enabled(Service):
    nginx = Service('nginx')
    assert nginx.is_running
    assert nginx.is_enabled


def test_request_blog(Request, Docker, Command):
    link = os.environ.get('DOCKER_HOST', 'localhost').lstrip('tcp://').rstrip(':2376')
    port = Docker('inspect_container', Command('hostname').stdout.strip())['NetworkSettings']['Ports']['80/tcp'][0]['HostPort']
    assert b'gtmanfred' in Request('http://{0}:{1}'.format(link, port)).content

def test_request_wedding(Request, Docker, Command):
    link = os.environ.get('DOCKER_HOST', 'localhost').lstrip('tcp://').rstrip(':2376')
    port = Docker('inspect_container', Command('hostname').stdout.strip())['NetworkSettings']['Ports']['80/tcp'][0]['HostPort']
    assert b'Wedding' in Request('http://{0}:{1}/wedding/'.format(link, port)).content


def test_pelican_directory(File):
    dirs = [
        '/home/pelican',
        '/home/pelican/gtmanfred',
        '/home/pelican/gtmanfred/site',
        '/home/pelican/gtmanfred/site/output',
    ]
    for dir_ in dirs:
        assert File(dir_).mode == 0o755
