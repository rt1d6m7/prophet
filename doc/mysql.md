`mysql -u root -p` // shell

`CREATE DATABASE db_name;` <> `DROP DATABASE db_name;` // create/delete database

`CREATE USER 'user_name'@'localhost' IDENTIFIED BY 'password';` <> `DROP USER user_name@localhost;` // create/delete user

`GRANT ALL PRIVILEGES ON db_name . * TO 'user_name'@'localhost';` <> `REVOKE ALL PRIVILEGES ON db_name . * FROM 'user_name'@'localhost';` // grant/revoke privileges

`select user, host from mysql.user;` // list users

`SHOW GRANTS FOR 'user_name'@'localhost';` // list user privileges

`SELECT table_schema "DB Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema;` // list database size


*Backup and Restore*

`mysqldump -u root -p -h localhost single_db > single_db.sql`


`mysql -u root -p -h localhost single_db < single_db.sql`
                 OR
`mysql -u root -p`
`MariaDB [(none)]> use db_name;`
                     `source /path/to/db.sql;` 

// docker

`docker exec CONTAINER /usr/bin/mysqldump -u root --password=root DATABASE > backup.sql`

`cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE`

// db_backup.sh (compressed dump and removes older than 30 days)

`#/bin/bash
/usr/bin/mysqldump db_name |  gzip -9 > /backup/database/db_name-$(date +%Y%m%d-%H%M).sql.gz
find /backup/database/* -mtime +30 -exec rm {} \;`

// crontab (1 am daily)

`00  01  *  *  * /bin/sh /var/scripts/db_backup.sh /dev/null 2>&1`
