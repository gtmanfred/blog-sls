{% set provider = salt['pillar.get']('cloud:providers:pillar-nova') %}
rackspace monitoring:
  pkgrepo.managed:
    - humanname: rackspace monitoring
    - name: deb http://stable.packages.cloudmonitoring.rackspace.com/debian-wheezy-x86_64 cloudmonitoring main
    - dist: cloudmonitoring
    - file: /etc/apt/sources.list.d/monitor.list
    - key_url: https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc

  pkg.latest:
    - name: rackspace-monitoring-agent
    - refresh: True

  cmd.run:
    - name: /usr/bin/rackspace-monitoring-agent --setup --username {{provider.get('user', '')}} --apikey {{provider.get('api_key', '')}}
    - unless: test -f /etc/rackspace-monitoring-agent.cfg

  service.running:
    - name: rackspace-monitoring-agent
    - enable: True

  event.send:
    - name: newcloud/monitoring/ready
    - data:
        name: {{salt['cmd.run']('xenstore-read name', '')}}
