R-repo:
 pkgrepo.managed:
   - humanname: R
   - name: deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/
   - file: /etc/apt/sources.list.d/R.list
   - keyid: 95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7
   - keyserver: keyserver.ubuntu.com
   - refresh_db: True

install_R:
  pkg.installed:
    - pkgs:
      - r-base
    - require:
      - pkgrepo: R-repo
