base:
  'blog.gtmanfred.com':
    - nginx
    - gtmanfred.app
    - wedding
    - letsencrypt
  '*':
    - vim
    - ssh
    - firewalld
