#!/bin/sh
#todo сделать сайт как переменную

sitePath="/srv/www/hino-dealer.aft.ru/htdocs"
mysqlBackupFileName=$(date '+hino-dealer_aft_ru_%Y-%m-%d_03h00m.%A.sql.gz')
mysqlBackupFilePathFrom="/var/backups/mysql/daily/hino-dealer_aft_ru/$mysqlBackupFileName"
mysqlBackupFilePathTo="$sitePath/last.sql.gz"
fileBackupFilePathTo="$sitePath/htdocs.zip"

rm -rf $mysqlBackupFilePathTo
rm -rf $fileBackupFilePathTo
cp $mysqlBackupFilePathFrom $mysqlBackupFilePathTo
zip -r $fileBackupFilePathTo "sitePath/." -x "upload/tmp*" "upload/logs*" ".git" "bitrix/cache/*" "bitrix/managed_cache/*" "bitrix/backup/*" "bitrix/tmp/*" "bitrix/php_interface/dbconn.php" "bitrix/.settings.php"