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

cleanup_ssh_config_2:
  file.replace:
    - name: /home/{{ username }}/.ssh/config
    - pattern: |
        \# begin of devops \.ssh\/config.+?end of devops \.ssh\/config
    - flags:
      - MULTILINE
      - DOTALL
    - repl: ""

/home/{{ username }}/.ssh/config:
  file.blockreplace:
    - marker_start: "# DO NOT EDIT - begin of devops"
    - marker_end: "# DO NOT EDIT - end of devops"
    - append_if_not_found: True
    - content: |
        Host *
            AddKeysToAgent yes
            IdentityFile ~/.ssh/id_rsa
        Host brandinvestor-*
            ProxyCommand ssh -W %h:%p brandinvestor.bi.plan-net.com
    - show_changes: True
