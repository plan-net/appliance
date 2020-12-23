chrome:
  cmd.run:
    - name: |
        test -f ./google-chrome-stable_current_amd64.deb && rm ./google-chrome-stable_current_amd64.deb
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        apt --yes install ./google-chrome-stable_current_amd64.deb
    - creates: /usr/bin/google-chrome
