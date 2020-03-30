cleanup_hosts:
  file.replace:
    - name: /etc/hosts
    - pattern: |
        \# START\: CORE4.+?END\: CORE4.+?\n
    - flags:
      - MULTILINE
      - DOTALL
    - repl: ""

cleanup_hosts_2:
  file.replace:
    - name: /etc/hosts
    - pattern: |
        \# begin of devops hosts.+?end of devops hosts.*\n?
    - flags:
      - MULTILINE
      - DOTALL
    - repl: ""

/etc/hosts:
  file.blockreplace:
    - name: /etc/hosts
    - marker_start: "# DO NOT EDIT - begin of devops"
    - marker_end: "# DO NOT EDIT - end of devops"
    - append_if_not_found: True
    - content: |
        127.0.0.1       testmongo
        10.249.1.70     pnbi_mongodb1 mongodb1
        10.249.1.71     pnbi_mongodb2 mongodb2

        10.249.1.6      pnbi_worker1 worker1
        10.249.1.11     pnbi_worker2 worker2
        10.249.1.14     pnbi_worker3 worker3
        10.249.1.7      pnbi_salt1 salt master pnbi_salt
        10.249.1.8      pnbi_app1 app1
        10.249.1.15     pnbi_app2 app2
        10.249.1.9      pnbi_conti1 conti1
        10.249.1.10     pnbi_file1 file1

        10.249.1.51     pnbi_jira_psql jira_psql

        10.249.2.2      pnbi_sftp1 sftp1
        10.249.2.3      pnbi_proxyExt proxyExt
        10.249.2.4      pnbi_postgresExt postgresExt
        10.249.2.5      pnbi_jira jira
        10.249.2.7      pnbi_git
        10.249.2.20     pnbi_psqlExt_audible psqlExt_audible
        10.249.1.98     pnbi_ipython ipython-server ipython-srv

        10.249.1.151    pnbi_staging_mongodb staging_mongodb
        10.249.1.152    pnbi_staging_worker1 staging_worker1
        10.249.1.153    pnbi_staging_app staging_app
        10.249.1.154    pnbi_staging_proxyExt staging_proxyExt staging.bi.plan-net.com

        10.249.1.100    salt.spm
        10.249.1.101    worker1.spm
        10.249.1.103    worker2.spm
        10.249.1.104    app1.spm
        10.249.2.25     proxy.spm

        10.249.1.160    app1.staging
        10.249.1.161    worker1.staging
        10.249.1.162    mongodb.staging


        35.158.149.95   core4_proxy

        # stage (aws)

        10.249.240.6    salt.stage          # master IN stage
        10.249.240.7    mongodb.stage       # mongodb IN stage
        10.249.240.153  app1.stage          # app IN stage
        10.249.240.100  app2.stage          # app IN stage
        10.249.240.212  worker1.stage       # worker IN stage
        10.249.240.194  worker2.stage       # worker IN stage
        10.249.240.31   proxy.stage         # proxy IN stage

    - show_changes: True
