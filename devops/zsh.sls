{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

clone_zsh:
  cmd.run:
    - name: |
        git clone https://github.com/robbyrussell/oh-my-zsh.git /home/{{ username }}/.oh-my-zsh
        cp /home/{{ username }}/.oh-my-zsh/templates/zshrc.zsh-template /home/{{ username }}/.zshrc
    - runas: {{ username }}
    - creates: /home/{{ username }}/.zshrc

change_zsh:
  cmd.run:
    - name: |
        usermod --shell /usr/bin/zsh {{ username }}
        touch /home/{{ username }}/.oh-my-zsh/.default
    - creates: /home/{{ username }}/.oh-my-zsh/.default

cleanup_zshrc:
  file.replace:
    - name: /home/{{ username }}/.zshrc
    - pattern: |
        \# START\: CORE4.+?END\: CORE4\-BOOTSTRAP[\s\d\.]+
    - flags:
      - MULTILINE
      - DOTALL
    - repl: ""


/home/{{ username }}/.zshrc:
  file.append:
    - text: |
        # begin of devops .zshrc
        source  ~/powerlevel9k/powerlevel9k.zsh-theme
        ZSH_THEME="powerlevel9k/powerlevel9k"
        ZSH_C4() {
            echo ""
        }

        POWERLEVEL9K_CUSTOM_C4="ZSH_C4"
        POWERLEVEL9K_CUSTOM_C4_FOREGROUND="yellow"
        POWERLEVEL9K_CUSTOM_C4_BACKGROUND="black"
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs custom_c4)

        ~/.pnbi_salt/appliance/update-bi.py
        # end of devops .zshrc
