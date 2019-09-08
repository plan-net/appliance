{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

conda_opt_uninstall:
  cmd.run:
    - name: |
        rm -Rf /opt/miniconda*


conda_install:
  cmd.run:
    - name: |
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
        bash /tmp/miniconda.sh -b -p /home/{{ username }}/miniconda3
        export PATH="/home/{{ username }}/miniconda3/bin:$PATH"
        /home/{{ username }}/miniconda3/bin/conda upgrade -q --all -y
        /home/{{ username }}/miniconda3/bin/conda install -q -y anaconda-navigator
        rm /tmp/miniconda.sh
        touch /home/{{ username }}/miniconda3/.core4_installed
    - runas: {{ username }}
    - require:
      - cmd: conda_opt_uninstall
    - creates: /home/{{ username }}/miniconda3/.core4_installed


/usr/share/applications/anaconda-navigator.desktop:
  file.managed:
    - contents: |
        [Desktop Entry]
        Encoding=UTF-8
        Version=1.0
        Type=Application
        Name=Anaconda Navigator
        Icon=/opt/miniconda3/lib/python3.7/site-packages/anaconda_navigator/static/images/anaconda.png
        Categories=Development;IDE;
        Exec=/opt/miniconda3/bin/python /opt/miniconda3/bin/anaconda-navigator
        Terminal=false
        StartupWMClass=Anaconda-Navigator


/usr/local/bin/conda:
  file.managed:
    - contents: |
        #!/bin/bash

        CONDA=/opt/miniconda3_v2/bin
        OLD_PATH=$PATH
        PATH=$CONDA:$OLD_PATH
        type deactivate >/dev/null 2>&1
        echo ""
        echo "entering conda environment at $CONDA"
        echo "type exit to leave"
        echo ""
        bash --rcfile <(cat ~/.bashrc ; echo 'PS1="(CONDA) $PS1 "')
        echo "welcome back"
        echo ""
    - mode: 755
