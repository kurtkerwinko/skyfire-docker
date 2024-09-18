#!/bin/bash
set -e

read -p "This will reset the entire database. Are you sure? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

_sql_passfile() {
	cat <<-EOF
		[client]
		host=${DATABASE_HOST}
		user=root
		password=${DATABASE_PASS}
	EOF
}

process_sql() {
	mysql --defaults-extra-file=<(_sql_passfile) \
		  --comments "$@"
}

import_sql_files() {
    count=`ls -1 "$1" 2>/dev/null | wc -l`
    if [ $count != 0 ]; then
        for sqlfile in "$1"; do
            echo "Importing ${sqlfile}"
            process_sql --database=$2 < "${sqlfile}"
        done
    fi
}

DB_ARCHIVE_FILENAME="${DB_ARCHIVE_URL##*/}"
DB_ARCHIVE_DIR="${DB_ARCHIVE_FILENAME%.*}"

cd /root
echo "Downloading DB archive..."
wget "${DB_ARCHIVE_URL}"
unzip "${DB_ARCHIVE_FILENAME}"

cd "/root/${DB_ARCHIVE_DIR}"
echo "Importing stored procedures..."
import_sql_files "./main_db/procs/*.sql" "world"

echo "Importing world data..."
import_sql_files "./main_db/world/*.sql" "world"

echo "Importing world updates..."
import_sql_files "./world_updates/*.sql" "world"

cd /root/skyfire/sql
echo "Importing base data..."
process_sql --database="auth" < "base/auth_database.sql"
process_sql --database="characters" < "base/characters_database.sql"

echo "Importing auth updates..."
import_sql_files "./updates/auth/*.sql" "auth"

echo "Importing characters updates..."
import_sql_files "./updates/characters/*.sql" "characters"

process_sql --database="auth" <<< "UPDATE realmlist SET address=\"${SKYFIRE_SERVER}\" WHERE id=1;"

echo "Done importing data"
