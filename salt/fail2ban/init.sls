fail2ban:
  pkg:
    - installed
  service:
    - running
    - listen:
      - pkg: fail2ban
