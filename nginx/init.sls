nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - reload: True
    - onchanges:
      - git: gtmanfred
      - git: gtmanfred_theme
      - file: /etc/nginx/conf.d/gtmanfred.conf
