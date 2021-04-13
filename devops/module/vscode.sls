{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

vscode_zshrc:
  file.blockreplace:
    - name: /home/{{ username }}/.zshrc
    - marker_start: "# begin of visual studio code -DO-NOT-EDIT-"
    - marker_end: "# end of visual studio code"
    - append_if_not_found: True
    - content: |
        # export SSH_ASKPASS=/usr/bin/ssh-askpass
    - show_changes: True

vscode:
  cmd.run:
    - name: |
        test -f ./vscode.deb && rm ./vscode.deb
        wget https://update.code.visualstudio.com/1.51.0/linux-deb-x64/stable -O vscode.deb
        apt --yes install ./vscode.deb
    - creates: /usr/bin/code
