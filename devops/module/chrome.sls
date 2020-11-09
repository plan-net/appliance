chrome:
  cmd.run:
    - name: |
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        apt install ./google-chrome-stable_current_amd64.deb
    - creates: /usr/bin/google-chrome
