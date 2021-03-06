install_python37_requirements:
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

configure_python37:
  cmd.run:
    #- name: ./configure --enable-optimizations
    # we disabled optimizations here, as it will take 30min+ enabling them,
    # resulting in a only ~10% performance boost.
    # As this is a development environment mostly used with active debugger
    # anyway, we can skip this.
    - name: |
        mkdir /tmp/install_python3.7
        cd /tmp/install_python3.7
        wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz
        echo d33e4aae66097051c2eca45ee3604803 Python-3.7.4.tar.xz | md5sum --check - || exit 1
        tar -xvf Python-3.7.4.tar.xz
        cd Python-3.7.4
        ./configure  # --enable-optimizations
        make
        make altinstall
        rm -Rf /tmp/install_python3.7
    - unless: which python3.7
    - require:
      - install_python37_requirements

