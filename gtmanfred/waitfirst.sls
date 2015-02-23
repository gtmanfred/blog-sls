sleep 30:
  cmd.run:
    - unless:
      - stat /etc/nginx/
    - order: 1
