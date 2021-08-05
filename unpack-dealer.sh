#!/bin/sh

echo 'Enter site path'
read sitePath

siteParentPath="$(dirname "$sitePath")"
tmpSitePath="$siteParentPath/tmp"

configSitePath="$siteParentPath/config"
zippedSitePath="$tmpSitePath/htdocs.zip"

echo 'Enter zip url'
read backupZipUrl

echo 'Enter http-auth user:'
read siteAuthUser

rm -rf "$tmpSitePath"
mkdir "$tmpSitePath"

wget --user="$siteAuthUser" --ask-password -P "$tmpSitePath/." "$backupZipUrl"

if test -f "$zippedSitePath"; then
    mv "$sitePath" "${sitePath}_old"
    mv "${sitePath}_orig" "$sitePath"
    rm -rf "${sitePath}_old"

    echo 'Unpacking zip...'
    unzip -qq "$zippedSitePath" -d "$tmpSitePath"
    rm -rf "$tmpSitePath/htdocs.zip"

    cp "$configSitePath/dbconn.php" "$tmpSitePath/bitrix/php_interface/dbconn.php"
    cp "$configSitePath/.settings.php" "$tmpSitePath/bitrix/.settings.php"
    cp "$configSitePath/.htaccess" "$tmpSitePath/.htaccess"
    cp "$configSitePath/.htpasswd" "$tmpSitePath/.htpasswd"

    echo 'Enter mysql host:'
    read mysqlHost

    echo 'Enter mysql user:'
    read mysqlUser

    echo 'Enter mysql dbname:'
    read mysqlDBName

    zcat "$tmpSitePath/last.sql.gz" | mysql -h"$mysqlHost" -u"$mysqlUser" -p "$mysqlDBName"

    mv "$sitePath" "${sitePath}_orig"
    mv "$tmpSitePath" "$sitePath"
else
    echo 'htdocs.zip is not exists'
fi



