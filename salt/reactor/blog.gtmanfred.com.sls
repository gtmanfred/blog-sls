{%- if salt.hashutil.github_signature(data['body'], salt.sdb.get('sdb://secrets/github_secret'), data['headers']['X-Hub-Signature']) %}
highstate_run:
  caller.state.apply:
    - args: []
{%- endif %}
