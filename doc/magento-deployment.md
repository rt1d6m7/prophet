`app/etc/env.php` // database connection

`composer install` // install packages

`bin/magento setup:upgrade` // install all modules and db update

`bin/magento setup:di:compile` // install custom module, module class override

`bin/magento static:content:deploy` // build static content into pub

`bin/magento cache:clean` // clean cache (var/page_cache)

`bin/magento cache:flush` // clean all cache

`bin/magento indexer:reindex` // data into flat table
