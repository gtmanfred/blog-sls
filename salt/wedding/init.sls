wedding repository:
  file.directory:
    - name: /var/www/html/wedding
    - makedirs: True
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - mode

  git.latest:
    - name: git://github.com/marneteen/Wedding.git
    - target: /var/www/html/wedding
