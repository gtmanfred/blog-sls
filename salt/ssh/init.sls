{% from "ssh/map.yml" import rawmap with context %}
{%- set ssh = salt['grains.filter_by'](rawmap, grain='os_family') %}

ssh:
  pkg:
    - installed

  service:
    - running
    - enable: True
    - name: {{ ssh.service }}
    - require:
      - pkg: ssh
    - watch:
      - file: /etc/ssh/sshd_config


/etc/ssh/sshd_config:
  file:
    - replace 
    - pattern: 'PermitRootLogin yes'
    - repl: 'PermitRootLogin without-password'
    - require:
      - pkg: ssh
