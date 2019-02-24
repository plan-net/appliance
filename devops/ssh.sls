{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

cleanup_ssh_config:
  file.replace:
    - name: /home/{{ username }}/.ssh/config
    - pattern: |
        \# START\: CORE4.+?END\: CORE4\-BOOTSTRAP[\s\d\.]+
    - flags:
      - MULTILINE
      - DOTALL
    - repl: ""

/home/{{ username }}/.ssh/config:
  file.prepend:
    - makedirs: true
    - text: |
        # begin of devops .ssh/config
        Host *
            AddKeysToAgent yes
            IdentityFile ~/.ssh/id_rsa
        # end of devops .ssh/config
