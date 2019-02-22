{% set username = salt['environ.get']('USERNAME') %}

test_run:
  cmd.run:
  - name: echo {{ username }}
