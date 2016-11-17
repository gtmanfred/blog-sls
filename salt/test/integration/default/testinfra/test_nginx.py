import os
import requests
import testinfra


def test_service_is_running_and_enabled(Service):
    nginx = Service('nginx')
    assert nginx.is_running
    assert nginx.is_enabled


def test_request_blog(Interface):
    link = 'http://{0}:8000/'.format(os.environ.get('DOCKER_IP', 'localhost'))
    assert requests.get(link)
