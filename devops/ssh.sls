{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

create_ssh_config:
  file.managed:
    - name: /home/{{ username }}/.ssh/config
    - contents: |
        # default empty devops file

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

        Host bi-worker*
            ProxyCommand ssh -W %h:%p brandinvestor.bi.plan-net.com

        Host *.aws
            ProxyCommand ssh -W %h:%p 35.158.149.95

        Host *.stage
            ProxyCommand ssh -W %h:%p salt.spm

        Host *.staging
            ProxyCommand ssh -W %h:%p salt.spm

        Host !salt.spm *.spm
            ProxyCommand ssh -W %h:%p salt.spm
    - show_changes: True
