import docker
import os
import pytest
import requests
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

