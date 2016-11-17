fail2ban:
  pkg:
    - latest 
  service:
    - running
    - listen:
      - pkg: fail2ban
