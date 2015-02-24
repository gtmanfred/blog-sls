{% set gtmanfred_venv = salt['pillar.get']('gtmanfred:venv') %}
{% set gtmanfred_proj = salt['pillar.get']('gtmanfred:proj') %}
{% set gtmanfred_user = salt['pillar.get']('gtmanfred:user') %}
{% set gtmanfred_theme = salt['pillar.get']('gtmanfred:theme') %}

include:
  - git
  - nginx
  - python.pip
  - python.virtualenv

{{ gtmanfred_user }}:
  user:
    - present
    - shell: /bin/bash
    - home: /home/{{ gtmanfred_user}}
    - uid: 2150
    - gid: 2150
    - groups:
      - sudo
    - require:
      - group: {{ gtmanfred_user }}
  group:
    - present
    - gid: 2150

gtmanfred_venv:
  virtualenv:
    - managed
    - name: {{ gtmanfred_venv }}
    - user: {{ gtmanfred_user }}
    - require:
      - pkg: python-virtualenv
      - user: {{ gtmanfred_user }}

gtmanfred:
  git:
    - latest
    - name: https://github.com/gtmanfred/blog.gtmanfred.com
    - rev: autoscale
    - target: {{ gtmanfred_proj }}
    - user: {{ gtmanfred_user }}
    - force: True
    - force_checkout: True
    - require:
      - pkg: git
      - virtualenv: gtmanfred_venv

refresh_pelican:
  cmd:
    - run
    - user: {{ gtmanfred_user }}
    - name: {{ gtmanfred_venv }}/bin/pelican -s {{gtmanfred_proj}}/pelicanconf.py
    - require:
      - virtualenv: gtmanfred_venv
    - onchanges:
      - git: gtmanfred
    - require:
      - pip: gtmanfred_pkgs

gtmanfred_theme:
  git:
    - latest
    - name: https://github.com/gravyboat/pelican-bootstrap3.git
    - target: {{ gtmanfred_theme }}
    - user: {{ gtmanfred_user }}
    - force: True
    - force_checkout: True
    - require:
      - virtualenv: gtmanfred_venv
      - git: gtmanfred

gtmanfred_pkgs:
  pip:
    - installed
    - bin_env: {{ gtmanfred_venv }}
    - requirements: {{ gtmanfred_proj }}/requirements.txt
    - user: {{ gtmanfred_user }}
    - require:
      - git: gtmanfred
      - pkg: python-pip
      - virtualenv: gtmanfred_venv

/etc/nginx/conf.d/gtmanfred.conf:
  file:
    - managed
    - source: salt://gtmanfred/files/gtmanfred.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - git: gtmanfred
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

health_checks:
  file.managed:
    - names:
      - /usr/share/nginx/www/health/enabled.html
      - /usr/share/nginx/www/health/monitoring.html
    - makedirs: True
    - order: last
    - contents: {{grains['nodename']}}
    - contents_newline: True

disable:
  file.absent:
    - name: /usr/share/nginx/www/health/enabled.html
    - order: 1
