firewall:
  pkg.latest:
    - name: firewalld

  service.running:
    - name: firewalld
    - listen:
      - firewalld: public

rules:
  firewalld.present:
    - name: public
    - default: True
    - services:
      - dhcpv6-client
      - ssh
      - http
      - https
