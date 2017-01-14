# gtmanfred environment settings

{% set gtmanfred_user = 'pelican' %}
{% set gtmanfred_venv = '/home/{0}/gtmanfred'.format(gtmanfred_user) %}
{% set gtmanfred_proj = '{0}/site'.format(gtmanfred_venv) %}
{% set gtmanfred_theme = '{0}/themes/'.format(gtmanfred_proj) %}
{% set gtmanfred_plugins = '{0}/plugins/'.format(gtmanfred_proj) %}
{% set gtmanfred_url = 'blog.gtmanfred.com' %}
{% set gtmanfred_root = '{0}/output'.format(gtmanfred_proj) %}

gtmanfred:
  user: {{ gtmanfred_user }}
  venv: {{ gtmanfred_venv }}
  proj: {{ gtmanfred_proj }}
  theme: {{ gtmanfred_theme }}
  plugins: {{ gtmanfred_plugins }}
  url: {{ gtmanfred_url }}
  root: {{ gtmanfred_root }}
