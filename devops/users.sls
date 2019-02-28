{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

user:
  user.present:
    - name: {{ username }}
    - remove_groups: false
    - optional_groups:
      - vboxsf
      - sudo
      - bla bla
