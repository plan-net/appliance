{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

/home/{{ username }}/.core4:
  file.directory:
    - user: michael
    - group: {{ username }}
    - mode: 700
    - makedirs: True

/home/{{ username }}/.core4/local.yaml.template:
  file.managed:
    - contents: |
        DEFAULT:
          mongo_url: mongodb://core:654321@localhost:27017
          mongo_database: core4dev

        logging:
          mongodb: INFO
          stderr: DEBUG
          stdout: ~

        worker:
          min_free_ram: 32

        api:
          setting:
            debug: True
            cookie_secret: very secret
          admin_password: hans

/home/{{ username }}/.core4/README.txt:
  file.managed:
    - contents: |
        This folder contains core4 local user configuration files.
        Use local.yaml.template and rename into local.yaml as a blueprint.
