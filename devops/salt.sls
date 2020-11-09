salt-minion:
  service.dead:
    - enable: false

/home/{{ username }}/.pnbi_salt/installed-modules:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - mode: 700
    - makedirs: True
