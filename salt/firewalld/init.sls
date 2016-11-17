firewall:
  pkg.latest:
    - name: firewalld

  service.running:
    - name: firewalld
    - listen:
      - firewalld: public

bind:
  firewalld.bind:
    - name: public
    - interfaces:
      - eth0

rules:
  firewalld.present:
    - name: public
    - default: True
    - ports:
      - 5000/tcp
    - services:
      - dhcpv6-client
      - ssh
      - http
