#!/bin/bash
set -e

SKYFIRE_CONFIG_PATH="/usr/local/skyfire-server/etc"
AUTHSERVER_CONFIG="${SKYFIRE_CONFIG_PATH}/authserver.conf"
WORLDSERVER_CONFIG="${SKYFIRE_CONFIG_PATH}/worldserver.conf"

DEFAULT_DATABASE_INFO="${DATABASE_HOST};3306;${DATABASE_USER};${DATABASE_PASS}"

echo "Setting database config for authserver"
sed -i "s|^\(LoginDatabaseInfo *= *\"\).*\(;[^;]*\"\)$|\1${DEFAULT_DATABASE_INFO}\2|" ${AUTHSERVER_CONFIG}

AUTHSERVER_PREFIX="AUTHSERVER_"
AUTHSERVER_ENV_CONF=$(env | grep "^${AUTHSERVER_PREFIX}" || true)
mapfile -t AUTHSERVER_CONF <<< "$AUTHSERVER_ENV_CONF"
echo "[authserver.conf] Setting custom config"
for conf_item in "${AUTHSERVER_CONF[@]}"; do
    CONF_KEY=${conf_item%%=*}
    CONF_KEY=${CONF_KEY#$AUTHSERVER_PREFIX}
    CONF_VALUE=${conf_item#*=}
    echo "[authserver.conf] Setting KEY=${CONF_KEY}, VALUE=${CONF_VALUE}"
    sed -i "s|^\(${CONF_KEY} *= *\).*$|\1${CONF_VALUE}|" ${AUTHSERVER_CONFIG}
done

echo "Setting database config for worldserver"
sed -i "s|^\(LoginDatabaseInfo *= *\"\).*\(;[^;]*\"\)$|\1${DEFAULT_DATABASE_INFO}\2|" ${WORLDSERVER_CONFIG}
sed -i "s|^\(WorldDatabaseInfo *= *\"\).*\(;[^;]*\"\)$|\1${DEFAULT_DATABASE_INFO}\2|" ${WORLDSERVER_CONFIG}
sed -i "s|^\(CharacterDatabaseInfo *= *\"\).*\(;[^;]*\"\)$|\1${DEFAULT_DATABASE_INFO}\2|" ${WORLDSERVER_CONFIG}

WORLDSERVER_PREFIX="WORLDSERVER_"
WORLDSERVER_ENV_CONF=$(env | grep "^${WORLDSERVER_PREFIX}" || true)
mapfile -t WORLDSERVER_CONF <<< "$WORLDSERVER_ENV_CONF"
echo "[worldserver.conf] Setting custom config"
for conf_item in "${WORLDSERVER_CONF[@]}"; do
    CONF_KEY=${conf_item%%=*}
    CONF_KEY=${CONF_KEY#$WORLDSERVER_PREFIX}
    CONF_VALUE=${conf_item#*=}
    echo "[worldserver.conf] Setting KEY=${CONF_KEY}, VALUE=${CONF_VALUE}"
    sed -i "s|^\(${CONF_KEY} *= *\).*$|\1${CONF_VALUE}|" ${WORLDSERVER_CONFIG}
done

echo "Config setup done"

exec "$@"
