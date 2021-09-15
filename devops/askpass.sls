askpass:
  pkg.installed:
    - pkgs:
        - ssh-askpass-gnome
        - ssh-askpass

  {% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

askpass_zshrc:
  file.blockreplace:
    - name: /home/{{ username }}/.zshrc
    - marker_start: "# begin of askpass -DO-NOT-EDIT-"
    - marker_end: "# end of askpasss"
    - append_if_not_found: True
    - content: |
        export SSH_ASKPASS=/usr/bin/ssh-askpass
    - show_changes: True
