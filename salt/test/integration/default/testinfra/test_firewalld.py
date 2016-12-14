import testinfra


def test_services(Command):
    assert all(x in Command('firewall-cmd --zone=public --list-services').stdout for x in ['dhcpv6-client', 'http', 'ssh', 'https'])


def test_ports(Command):
    assert not Command('firewall-cmd --zone=public --list-ports').stdout.strip()
