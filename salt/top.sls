base:
  'blog.gtmanfred.com':
    - letsencrypt
    - nginx
    - gtmanfred.app
    - wedding
  '*':
    - vim
    - ssh
    - firewalld
