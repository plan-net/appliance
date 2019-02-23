{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

user:
  user.present:
    - name: {{ username }}
    - groups:
      - vboxsf
      - sudo
