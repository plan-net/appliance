install_R_requirements:
  pkg.installed:
    - pkgs:
      - dirmngr
      - apt-transport-https
      - ca-certificates
      - software-properties-common
      - gnupg2
      - libssl-dev
      - libsasl2-dev

R-repo:
 pkgrepo.managed:
   - humanname: R
   - name: deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/
   - file: /etc/apt/sources.list.d/R.list
   - keyid: E19F5F87128899B192B1A2C2AD5F960A256A04AF
   - keyserver: keys.gnupg.net
   - refresh_db: True

install_R:
  pkg.installed:
    - pkgs:
      - r-base
    - require:
      - pkgrepo: R-repo
