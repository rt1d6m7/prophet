`mongo` // shell

`use admin` // switch to admin database

`db.createUser({ user: "root", pwd: "rootpassword", roles: [{ role: "root", db: "admin" }] })` // create root user

`db.auth("root", "rootpassword")` // switch root user

`show dbs` // list database

`use db_name` // select database

`show collections` // view collections

`db.collection_name.find()` // view datas in the collection

`db.collection_name.remove({})` // delete all the documents from a collection

*https://docs.mongodb.com/manual/reference/mongo-shell/*

*Backup and Restore*

`mongodump --db db_name --out /path`

`mongorestore --db db_name /path/db_name`

