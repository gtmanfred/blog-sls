packages:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'Debian' %}
      - vim
      {% elif grains['os_family'] == 'RedHat' %}
      - vim-enhanced
      {% endif %}
