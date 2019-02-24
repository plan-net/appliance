cleanup_hosts:
  file.replace:
    - name: /etc/hosts
    - pattern: |
        \# START\: CORE4.+?END\: CORE4.+?\n
    - flags:
      - MULTILINE
      - DOTALL
    - repl: ""

/etc/hosts:
  file.append:
    - text: |
        # begin of devops hosts
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
        # end of devops hosts
