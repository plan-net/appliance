{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

conda_install:
  cmd.run:
    - name: |
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
        /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -u -p /opt/miniconda3
        export PATH="/opt/miniconda3/bin:$PATH"
        /opt/miniconda3/bin/conda upgrade --all -y
        /opt/miniconda3/bin/conda install -q -y pandas anaconda-navigator rstudio jupyterlab pymongo psycopg2
        rm Miniconda3-latest-Linux-x86_64.sh
        chown -R -v {{ username }}:root /opt/miniconda3
        touch /opt/miniconda3/.core4_installed
    - creates: /opt/miniconda3/.core4_installed

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

        CONDA=/opt/miniconda3/bin
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