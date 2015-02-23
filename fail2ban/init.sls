fail2ban:
  pkg:
    - installed
  service:
    - running
    - onchanges:
      - pkg: fail2ban
    - require:
      - pkg: fail2ban
