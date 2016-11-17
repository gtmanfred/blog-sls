firewall:
  pkg.latest:
    - name: firewalld

  service.running:
    - name: firewalld

  firewalld.present:
    - name: public
    - default: True
    - masquerade: True
    - ports:
      - 5000/tcp
    - services:
      - dhcpv6-client
      - ssh
      - http
