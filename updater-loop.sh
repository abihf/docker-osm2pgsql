#!/bin/sh

db_user=${DB_ENV_POSTGRES_USER:-postgres}
db_pass=${DB_ENV_POSTGRES_PASSWORD}
db_name=${DB_ENV_POSTGRES_DB:-$db_user}

db_host=$DB_PORT_5432_TCP_ADDR
db_port=$DB_PORT_5432_TCP_PORT

mkdir -p /update/new
mkdir -p /update/add
mkdir -p /update/processed

update() {
        osm2pgsql -H $db_host -P $db_port -U $db_user -W $db_pass -d $db_name --slim $@
}

for f in /update/new/* ; do
        update "$f"
done
