sleep 10:
  cmd.run:
    - unless:
      - stat /etc/nginx/
    - order: 1
