base:
  'blog*':
    - gtmanfred.waitfirst
    - nginx
    - gtmanfred.app
  'salt*':
    - srv
  '*':
    - vim
    - ssh
