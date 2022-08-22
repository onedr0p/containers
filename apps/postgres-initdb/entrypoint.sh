#!/usr/bin/env bash

export PGHOST="${POSTGRES_HOST}"
export PGUSER="${POSTGRES_SUPER_USER}"
export PGPASSWORD="${POSTGRES_SUPER_PASS}"

if [[ -z "${PGHOST}" || -z "${PGHOST}" || -z "${PGPASSWORD}" || -z "${POSTGRES_USER}" || -z "${POSTGRES_PASS}" || -z "${POSTGRES_DB}" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration ..."
    exit 1
fi

until pg_isready; do
    printf "\e[1;32m%-6s\e[m\n" "Waiting for Host '${PGHOST}' ..."
    sleep 1
done

if [[ "${POSTGRES_USER_RESET}" == "true" && "${POSTGRES_RESET_CONFIRM}" == "YES" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Drop User ${POSTGRES_USER} ..."
    dropuser "${POSTGRES_USER}"
fi

user_exists=$(\
    psql \
        --tuples-only \
        --csv \
        --command "SELECT 1 FROM pg_roles WHERE rolname = '${POSTGRES_USER}'"
    )

if [[ -z "${user_exists}" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Create User ${POSTGRES_USER} ..."
    createuser ${POSTGRES_USER_FLAGS} "${POSTGRES_USER}"
    printf "\e[1;32m%-6s\e[m\n" "Update User Password ..."
    psql --command "alter user \"${POSTGRES_USER}\" with encrypted password '${POSTGRES_PASS}';"
fi

for init_db in ${POSTGRES_DB}
do
    if [[ "${POSTGRES_RESET}" == "true" && "${POSTGRES_RESET_CONFIRM}" == "YES" ]]; then
        printf "\e[1;32m%-6s\e[m\n" "Drop Database ${init_db} ..."
        dropdb "${init_db}"
    fi

    database_exists=$(\
    psql \
        --tuples-only \
        --csv \
        --command "SELECT 1 FROM pg_database WHERE datname = '${init_db}'"
    )

    if [[ -z "${database_exists}" ]]; then
        printf "\e[1;32m%-6s\e[m\n" "Create Database ${init_db} ..."
        createdb --owner "${POSTGRES_USER}" "${init_db}"
    fi

    printf "\e[1;32m%-6s\e[m\n" "Update User Privileges on Database ..."
    psql --command "grant all privileges on database \"${init_db}\" to \"${POSTGRES_USER}\";"
done
