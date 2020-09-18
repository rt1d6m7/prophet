`su - postgres`
`psql`

`\l+` // list of database

`\c db_name` // select database

`\dt` // list table

`\du` // list of roles

`\x` // easier to read display mode

`CREATE DATABASE db_name;` `DROP DATABASE db_name;`

`CREATE USER user_name WITH PASSWORD 'password';` `DROP USER user_name;`

`GRANT ALL PRIVILEGES ON DATABASE db_name TO user;` `REVOKE ALL PRIVILEGES ON DATABASE db_name FROM user;` // SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE, or ALL

`ALTER DATABASE old_db_name RENAME TO new_db_name;`

`ALTER DATABASE db_name OWNER TO new_owner;`

`ALTER USER user_name WITH PASSWORD 'password';`

`ALTER USER user_name WITH ROLE;` // SUPERUSER | NOSUPERUSER, CREATEDB | NOCREATEDB, CREATEROLE | NOCREATEROLE, CREATEUSER | NOCREATEUSER, INHERIT | NOINHERIT, LOGIN | NOLOGIN, REPLICATION | NOREPLICATION, [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'

*Save output to a CSV file*

`COPY (SELECT * from users) To '/tmp/output.csv' With CSV;` // copy command

//psql interactive

`\c db_name`

`\f ','`

`\a`

`\o '/tmp/output.csv'`

`SELECT * from users;`

`\q`

*Backup and Restore*

`su postgres`

`createdb -O owner_name -T original_db new_db` // clone

`pg_dump -U user single_db > single_db.sql` // backup

`psql -U user single_db < single_db.sql` // restore

`docker exec CONTAINER /usr/bin/pg_dump -U USER DATABASE | gzip -9 > backup.sql.gz` // backup

`cat backup_dump.sql | docker exec -i CONTAINER psql -U USER -d db_name` // restore

// db_backup.sh (compressed dump and removes older than 30 days)

`#/bin/bash
sudo -u postgres pg_dump db_name | gzip -9 > /backup/database/db_name-$(date +%Y%m%d-%H%M).sql.gz
find /backup/database/* -mtime +30 -exec rm {} \;`

// crontab (1 am daily)

`00  01  *  *  * /bin/sh /var/scripts/db_backup.sh /dev/null 2>&1`