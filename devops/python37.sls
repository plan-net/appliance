python37_download:
  archive:
    - unless: which python3.7
    - extracted
    - name: /tmp/Python3.7
    - source: https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz
    - source_hash: md5=d33e4aae66097051c2eca45ee3604803
    - archive_format: tar
    - tar_options: z
    - keep: false

configure_python37:
  cmd.run:
    #- name: ./configure --enable-optimizations
    # we disabled optimizations here, as it will take 30min+ enabling them,
    # resulting in a only ~10% performance boost.
    # As this is a development environment mostly used with active debugger
    # anyway, we can skip this.
    - name: ./configure
    - unless: which python3.7
    - cwd: /tmp/Python3.7/Python-3.7.4

make_python37:
  cmd.run:
    - name: make
    - unless: which python3.7
    - cwd: /tmp/Python3.7/Python-3.7.4

install_python37:
  cmd.run:
    - name: make altinstall
    - unless: which python3.7
    - cwd: /tmp/Python3.7/Python-3.7.4

