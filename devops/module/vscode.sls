vscode:
  cmd.run:
    - name: |
        test -f ./vscode.deb && rm ./vscode.deb
        wget https://update.code.visualstudio.com/1.51.0/linux-deb-x64/stable -O vscode.deb
        apt --yes install ./vscode.deb
    - creates: /usr/bin/code
