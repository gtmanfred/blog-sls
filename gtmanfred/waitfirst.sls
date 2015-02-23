salt://gtmanfred/files/wait.sh:
  cmd.script:
    - unless:
      - stat /etc/nginx/
    - order: 1
