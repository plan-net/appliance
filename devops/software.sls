system_prerequisites:
  pkg.installed:
    - refresh: True
    - pkgs:
      - linux-headers-amd64
      - gcc
      - make
      - perl
      - sudo
      - tmux
      - screen
      - git
      - curl
      - wget
      - mc
      - htop
      #- gimp
      - runit
      - runit-systemd
      - zsh
      #- python3-venv
      - libgconf-2-4
      #- python3-dev
      #- python-dev
      - build-essential
      - libappindicator3-1
      - meld
      - python-tk
      - libcanberra-gtk-module
      #- chromium

# chrome:
#   cmd.run:
#     - name: |
#         wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#         dpkg -i google-chrome-stable_current_amd64.deb
#     - creates: /usr/bin/google-chrome

#compass:
#  cmd.run:
#    - name: |
#        wget https://downloads.mongodb.com/compass/mongodb-compass-community_1.19.12_amd64.deb
#        dpkg -i mongodb-compass-community_1.19.12_amd64.deb
#        rm mongodb-compass-community_1.19.12_amd64.deb
#    - creates: /usr/bin/mongodb-compass-community

nodejs:
  cmd.run:
    - name: |
        curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
        apt-get install -y nodejs
    - creates: /usr/bin/nodejs

yarn:
  cmd.run:
    - name: |
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
        apt update
        apt install yarn
    - creates: /usr/bin/yarn
    - require:
      - cmd: nodejs

askpass:
  pkg.installed:
    - pkgs:
        - ssh-askpass-gnome
        - ssh-askpass

askpass_zshrc:
  file.blockreplace:
    - name: /home/{{ username }}/.zshrc
    - marker_start: "# begin of askpass -DO-NOT-EDIT-"
    - marker_end: "# end of askpasss"
    - append_if_not_found: True
    - content: |
        export SSH_ASKPASS=/usr/bin/ssh-askpass
    - show_changes: True
