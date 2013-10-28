postgresql:
    pkg:
        - installed
        - name: postgresql-9.1
    service:
        - running
        - watch:
            - file: /etc/postgresql/9.1/main/pg_hba.conf
        - require:
            - file: pg_hba.conf

postgresql-contrib:
    pkg:
        - installed
        - require:
                - pkg: postgresql

pg_hba.conf:
    file.managed:
        - name: /etc/postgresql/9.1/main/pg_hba.conf
        - source: salt://database/pg_hba.conf
        - user: postgres
        - group: postgres
        - mode: 644
        - require:
            - pkg: postgresql

db_user:
    postgres_user.present:
        - name: caesar
        - password: password
        - createdb: True
        - user: postgres
        - require:
            - pkg: postgresql