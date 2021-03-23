{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

/srv/core3:
  file.directory:
    - user: {{ username }}
    - group: root
    - mode: 770
    - makedirs: True

{% for d in ['proc', 'transfer', 'arch', 'arch/other', 'temp'] %}

core_local_{{ d }}:
  file.directory:
    - name: /srv/core3/{{ d }}
    - user: {{ username }}
    - group: root
    - mode: 770
    - makedirs: True

{% endfor %}

install_pip:
  cmd.run:
    - unless: bash -c "test `pip --version | awk '{ print $2 }'` == 9.0.1"
    - name: wget https://bootstrap.pypa.io/get-pip.py; python get-pip.py; pip install -I pip==9.0.1; rm get-pip.py

extra_packages:
  pkg.installed:
    - refresh: True
    - pkgs:
      - build-essential
      - python-dev
      - libpq-dev
      - dirmngr
      - apt-transport-https
      - ca-certificates
      - software-properties-common
      - gnupg2

fortran_base:
  pkg.installed:
    - pkgs:
      - swig3.0
      - swig
      - gfortran-6
      - gfortran

/home/{{ username }}/.core:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - mode: 700
    - makedirs: True

/home/{{ username }}/.core/local.conf.template:
  file.managed:
    - contents: |
        [DEFAULT]

        mongo_url = mongodb://core:654321@localhost:27017
        mongo_database = core3dev

        auth_username = admin
        auth_password = hans

        [logging]
        mongo_logging = True
        mongo_log_level = INFO
        console_log_level = DEBUG
        console_log_format = %%(asctime)s [%%(identifier)s] %%(levelname)-8s - %%(message)s

        [job]
        worker_polling = 0.25
        progress_interval = 5.0

        [api]

        admin_password = hans
        secret_key = hello world

        codecs = /home/{{ username }}/.core/codecs

/home/{{ username }}/.core/README.txt:
  file.managed:
    - contents: |
        This folder contains core3 local user configuration files.
        Use local.conf.template and rename into local.conf as a blueprint.

/home/{{ username }}/.core/codecs:
  file.managed:
    - contents: |
        i would like to be a chicken

python-pip:
  pkg.installed

pbr:
  pip.installed:
    - require:
        - pkg: python-pip

virtualenvwrapper:
  pip.installed:
    - require:
      - pip: pbr

virtualenvwrapper_zshrc:
  file.blockreplace:
    - name: /home/{{ username }}/.zshrc
    - marker_start: "# begin of devops virtualenvwrapper -DO-NOT-EDIT-"
    - marker_end: "# end of devops virtualenvwrapper"
    - append_if_not_found: True
    - content: |
        export WORKON_HOME=~/.virtualenvs
        mkdir -p $WORKON_HOME
        source /usr/local/bin/virtualenvwrapper.sh
    - show_changes: True

add_apt_repository_35:
  cmd.run:
    - name: |
        echo "#! /usr/bin/python3.5\n`tail +2 /usr/bin/add-apt-repository`" > /usr/bin/add-apt-repository
    - unless: head -n 1 /usr/bin/add-apt-repository | grep python3.5
    - require:
        - pkgrepo: R-repo


