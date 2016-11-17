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
    - require:
      - group: {{ gtmanfred_user }}
  group:
    - present
    - gid: 2150
  file:
    - directory
    - name: /home/{{gtmanfred_user}}
    - mode: 755

gtmanfred_venv:
  virtualenv:
    - managed
    - name: {{ gtmanfred_venv }}
    - user: {{ gtmanfred_user }}
    - require:
      - pkg: python-virtualenv
      - user: {{ gtmanfred_user }}

  pip:
    - installed
    - bin_env: {{ gtmanfred_venv }}
    - requirements: {{ gtmanfred_proj }}/requirements.txt
    - user: {{ gtmanfred_user }}
    - require:
      - git: gtmanfred
      - pkg: python-pip
      - virtualenv: gtmanfred_venv

gtmanfred:
  git:
    - latest
    - name: https://github.com/gtmanfred/blog.gtmanfred.com
    - target: {{ gtmanfred_proj }}
    - user: {{ gtmanfred_user }}
    - force_checkout: True
    - require:
      - pkg: git
      - virtualenv: gtmanfred_venv
    - listen_in:
      - service: nginx

gtmanfred_theme:
  git:
    - latest
    - name: https://github.com/gravyboat/pelican-bootstrap3.git
    - target: {{ gtmanfred_theme }}
    - user: {{ gtmanfred_user }}
    - force_checkout: True
    - require:
      - virtualenv: gtmanfred_venv
      - git: gtmanfred
    - listen_in:
      - service: nginx

refresh_pelican:
  cmd:
    - run
    - runas: {{ gtmanfred_user }}
    - name: {{ gtmanfred_venv }}/bin/pelican -s {{gtmanfred_proj}}/pelicanconf.py
    - require:
      - virtualenv: gtmanfred_venv
      - pip: gtmanfred_venv
      - git: gtmanfred
      - git: gtmanfred_theme
    - onchanges:
      - git: gtmanfred

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://gtmanfred/files/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - git: gtmanfred
      - pkg: nginx
    - listen_in:
      - service: nginx

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
    - listen_in:
      - service: nginx

/etc/nginx/sites-enabled/default:
  file:
    - absent
