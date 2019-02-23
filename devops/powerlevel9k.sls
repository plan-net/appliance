{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

clone_powerlevel9k:
  cmd.run:
    - name: |
        git clone https://github.com/bhilburn/powerlevel9k.git /home/{{ username }}/powerlevel9k
    - runas: {{ username }}
    - creates: /home/{{ username }}/powerlevel9k

powerlevel9k_fonts:
  cmd.run:
    - name: |
        wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
        mv PowerlineSymbols.otf /usr/share/fonts
        fc-cache -v -f /usr/share/fonts/
        wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
        mv 10-powerline-symbols.conf /etc/fonts/conf.d
    - creates: /usr/share/fonts/PowerlineSymbols.otf
