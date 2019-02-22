{% set username = salt['environ.get']('USERNAME') %}

user:
  user.present:
    - name: {{ username }}
    - groups:
      - vboxsf
      - sudo
