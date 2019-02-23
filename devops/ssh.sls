{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

/home/{{ username }}/.ssh/config:
  file.prepend:
    - makedirs: true
    - text: |
        # begin of devops .ssh/config
        Host *
            AddKeysToAgent yes
            IdentityFile ~/.ssh/id_rsa
        # end of devops .ssh/config
