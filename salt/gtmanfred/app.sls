{% set gtmanfred_venv = salt['pillar.get']('gtmanfred:venv') %}
{% set gtmanfred_proj = salt['pillar.get']('gtmanfred:proj') %}
{% set gtmanfred_user = salt['pillar.get']('gtmanfred:user') %}
{% set gtmanfred_theme = salt['pillar.get']('gtmanfred:theme') %}
{% set gtmanfred_plugins = salt['pillar.get']('gtmanfred:plugins') %}

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
      - pkg: python2-pip
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
    - name: https://github.com/getpelican/pelican-themes.git
    - target: {{ gtmanfred_theme }}
    - user: {{ gtmanfred_user }}
    - force_checkout: True
    - depth: 1
    - require:
      - virtualenv: gtmanfred_venv
      - git: gtmanfred
    - listen_in:
      - service: nginx

gtmanfred_plugins:
  git:
    - latest
    - name: https://github.com/getpelican/pelican-plugins
    - target: {{ gtmanfred_plugins }}
    - user: {{ gtmanfred_user }}
    - force_checkout: True
    - depth: 1
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
      - git: gtmanfred_plugins
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

{%- if pillar.ssl is defined %}
ssl_cert:
  file.managed:
    - names:
      - /etc/pki/tls/certs/{{salt.pillar.get('gtmanfred:url')}}.crt:
        - contents_pillar: ssl:cert
      - /etc/pki/tls/private/{{salt.pillar.get('gtmanfred:url')}}.key:
        - contents_pillar: ssl:key
    - listen_in:
      - service: nginx
  cmd.run:
    - name: openssl dhparam -out /etc/pki/tls/certs/dhparam.pem 4096
    - creates: /etc/pki/tls/certs/dhparam.pem
{%- endif %}

/etc/nginx/sites-enabled/default:
  file:
    - absent
