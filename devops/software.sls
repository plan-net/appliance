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
      - gimp
      - runit
      - runit-systemd
      - zsh
      - python3-venv
      - libgconf-2-4
      - python3-dev
      - python-dev
      - build-essential
      - libappindicator3-1
      - meld
      - python-tk

chrome:
  cmd.run:
    - name: |
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        dpkg -i google-chrome-stable_current_amd64.deb
    - creates: /usr/bin/google-chrome

compass:
  cmd.run:
    - name: |
        wget https://downloads.mongodb.com/compass/mongodb-compass-community_1.19.12_amd64.deb
        dpkg -i mongodb-compass-community_1.19.12_amd64.deb
    - creates: /usr/bin/mongodb-compass-community
