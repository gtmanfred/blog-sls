import os
import pytest
import requests
import testinfra


@pytest.fixture()
def Request():
    def f(arg):
        return requests.get(arg)
    return f


def test_service_is_running_and_enabled(Service):
    nginx = Service('nginx')
    assert nginx.is_running
    assert nginx.is_enabled


def test_request_blog(Request):
    link = 'http://{0}:8000/'.format(os.environ.get('DOCKER_IP', 'localhost'))
    assert 'gtmanfred' in Request(link).content
