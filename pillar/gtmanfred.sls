# gtmanfred environment settings

{% set gtmanfred_user = 'pelican' %}
{% set gtmanfred_venv = '/home/{0}/gtmanfred'.format(gtmanfred_user) %}
{% set gtmanfred_proj = '{0}/site'.format(gtmanfred_venv) %}
{% set gtmanfred_themes = '{0}/themes/'.format(gtmanfred_proj) %}
{% set gtmanfred_plugins = '{0}/plugins/'.format(gtmanfred_proj) %}
{% set gtmanfred_url = 'blog.gtmanfred.com' %}
{% set gtmanfred_root = '{0}/output'.format(gtmanfred_proj) %}

gtmanfred:
  user: {{ gtmanfred_user }}
  venv: {{ gtmanfred_venv }}
  proj: {{ gtmanfred_proj }}
  themes: {{ gtmanfred_themes }}
  plugins: {{ gtmanfred_plugins }}
  url: {{ gtmanfred_url }}
  root: {{ gtmanfred_root }}

letsencrypt:
  config: |
    server = https://acme-v01.api.letsencrypt.org/directory
    email = danielwallace@gtmanfred.com
    authenticator = webroot
    webroot-path = {{gtmanfred_root}}
    agree-tos = True
    renew-by-default = True
  domainsets:
    www:
      - blog.gtmanfred.com
