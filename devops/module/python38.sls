install_python38_requirements:
  pkg.installed:
    - pkgs:
      - build-essential
      - checkinstall
      - libreadline-gplv2-dev
      - libncursesw5-dev
      - libssl-dev
      - libsqlite3-dev
      - tk-dev
      - libgdbm-dev
      - libc6-dev
      - libbz2-dev
      - libffi-dev
      - zlib1g-dev
      - liblzma-dev

configure_python38:
  cmd.run:
    #- name: ./configure --enable-optimizations
    # we disabled optimizations here, as it will take 30min+ enabling them,
    # resulting in a only ~10% performance boost.
    # As this is a development environment mostly used with active debugger
    # anyway, we can skip this.
    - name: |
        mkdir /tmp/install_python3.8
        cd /tmp/install_python3.8
        wget https://www.python.org/ftp/python/3.8.6/Python-3.8.6.tgz
        echo ea132d6f449766623eee886966c7d41f Python-3.8.6.tgz | md5sum --check - || exit 1
        tar -xvf Python-3.8.6.tgz
        cd Python-3.8.6
        ./configure --enable-optimizations
        make
        make altinstall
        rm -Rf /tmp/install_python3.8
    - unless: which python3.8
    - require:
      - install_python38_requirements

python3.8_link:
  file.symlink:
    - name: /usr/local/bin/python3.8
    - target: /etc/sv/mongodb
