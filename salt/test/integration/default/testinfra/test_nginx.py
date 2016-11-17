import docker
import os
import pytest
import requests
import testinfra
from docker.client import Client
import docker.tls as tls


@pytest.fixture()
def Docker(*args, **kwargs):
    CERTS = os.environ.get('DOCKER_CERT_PATH', False)

    if CERTS:
        tls_config = tls.TLSConfig(
            client_cert=(os.path.join(CERTS, 'cert.pem'), os.path.join(CERTS,'key.pem')),
            ca_cert=os.path.join(CERTS, 'ca.pem'),
            verify=True
        )
        client = Client(base_url=os.environ.get('DOCKER_HOST').replace('tcp', 'https'), tls=tls_config)
    else:
        client = Client(base_url='unix://var/run/docker.sock')
    def f(function, *args, **kwargs):
        return getattr(client, function)(*args, **kwargs)
    return f


@pytest.fixture()
def Request():
    def f(arg):
        return requests.get(arg)
    return f


def test_service_is_running_and_enabled(Service):
    nginx = Service('nginx')
    assert nginx.is_running
    assert nginx.is_enabled


def test_request_blog(Request, Docker, Command):
    link = os.environ.get('DOCKER_HOST', 'localhost').lstrip('tcp://').rstrip(':2376')
    port = Docker('inspect_container', Command('hostname').stdout.strip())['NetworkSettings']['Ports']['80/tcp'][0]['HostPort']
    assert 'gtmanfred' in Request('http://{0}:{1}'.format(link, port)).content


def test_pelican_directory(File):
    dirs = [
        '/home/pelican',
        '/home/pelican/gtmanfred',
        '/home/pelican/gtmanfred/site',
        '/home/pelican/gtmanfred/site/output',
    ]
    for dir_ in dirs:
        assert File(dir_).mode == 0o755
