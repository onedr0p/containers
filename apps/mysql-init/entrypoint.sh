#!/usr/bin/env bash

export INIT_MYSQL_SUPER_USER=${INIT_MYSQL_SUPER_USER:-root}

if [[ -z "${INIT_MYSQL_HOST}"       ||
      -z "${INIT_MYSQL_SUPER_PASS}" ||
      -z "${INIT_MYSQL_USER}"       ||
      -z "${INIT_MYSQL_PASS}"       ||
      -z "${INIT_MYSQL_DBNAME}"
]]; then
    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration - missing a required environment variable"
    [[ -z "${INIT_MYSQL_HOST}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_HOST: unset"
    [[ -z "${INIT_MYSQL_SUPER_PASS}" ]] && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_SUPER_PASS: unset"
    [[ -z "${INIT_MYSQL_USER}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_USER: unset"
    [[ -z "${INIT_MYSQL_PASS}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_PASS: unset"
    [[ -z "${INIT_MYSQL_DBNAME}" ]]     && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_DBNAME: unset"
    exit 1
fi

export MYSQL_PWD="${INIT_MYSQL_SUPER_PASS}"

until mysqladmin ping --host="${INIT_MYSQL_HOST}" --user="${INIT_MYSQL_SUPER_USER}"; do
    printf "\e[1;32m%-6s\e[m\n" "Waiting for Host '${INIT_MYSQL_HOST}' ..."
    sleep 1
done

user_exists=$(\
    mysql \
        --host="${INIT_MYSQL_HOST}" \
        --user="${INIT_MYSQL_SUPER_USER}" \
        --execute="SELECT 1 FROM mysql.user WHERE user = '${INIT_MYSQL_USER}'"
)

if [[ -z "${user_exists}" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Create User ${INIT_MYSQL_USER} ..."
    mysql --host="${INIT_MYSQL_HOST}" --user="${INIT_MYSQL_SUPER_USER}" --execute="CREATE USER ${INIT_MYSQL_USER}@'%' IDENTIFIED BY '${INIT_MYSQL_PASS}';"
fi

for dbname in ${INIT_MYSQL_DBNAME}; do
    database_exists=$(\
        mysql \
            --host="${INIT_MYSQL_HOST}" \
            --user="${INIT_MYSQL_SUPER_USER}" \
            --execute="SELECT 1 FROM information_schema.schemata WHERE schema_name = '${dbname}'"
    )
    if [[ -z "${database_exists}" ]]; then
        printf "\e[1;32m%-6s\e[m\n" "Create Database ${dbname} ..."
        mysql --host="${INIT_MYSQL_HOST}" --user="${INIT_MYSQL_SUPER_USER}" --execute="CREATE DATABASE IF NOT EXISTS ${dbname};"
    fi
    printf "\e[1;32m%-6s\e[m\n" "Update User Privileges on Database ..."
    mysql --host="${INIT_MYSQL_HOST}" --user="${INIT_MYSQL_SUPER_USER}" --execute="GRANT ALL PRIVILEGES ON ${dbname}.* TO '${INIT_MYSQL_USER}'@'%'; FLUSH PRIVILEGES;"
done

# Check if the /docker-entrypoint-initdb.d/ folder exists
if [ -d "/docker-entrypoint-initdb.d/" ]; then
    for sql_file in /docker-entrypoint-initdb.d/*.sql; do
        echo "Executing $sql_file"
        echo "mysql -h ${INIT_MYSQL_HOST} -u ${INIT_MYSQL_USER} -p${INIT_MYSQL_PASS} ${INIT_MYSQL_DBNAME} < $sql_file"
        mysql -h ${INIT_MYSQL_HOST} -u ${INIT_MYSQL_USER} -p${INIT_MYSQL_PASS} ${INIT_MYSQL_DBNAME} < $sql_file
    done
else
    echo "The /docker-entrypoint-initdb.d/ folder does not exist. Skipping SQL file execution."
fi
