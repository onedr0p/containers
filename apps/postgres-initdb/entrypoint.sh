#!/usr/bin/env bash

export PGHOST="${POSTGRES_HOST}"
export PGUSER="${POSTGRES_SUPER_USER}"
export PGPASSWORD="${POSTGRES_SUPER_PASS}"

if [[ -z "${PGHOST}" || -z "${PGHOST}" || -z "${PGPASSWORD}" || -z "${POSTGRES_USER}" || -z "${POSTGRES_PASS}" || -z "${POSTGRES_DB}" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration ..."
    exit 1
fi

if [[ "${POSTGRES_RESET}" == "true" && "${POSTGRES_RESET_CONFIRM}" == "YES" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Drop Database ${POSTGRES_DB} ..."
    dropdb "${POSTGRES_DB}"
    printf "\e[1;32m%-6s\e[m\n" "Drop User ${POSTGRES_USER} ..."
    dropuser "${POSTGRES_USER}"
fi

database_exists=$(\
psql \
    --tuples-only \
    --csv \
    --command "SELECT 1 FROM pg_database WHERE datname = '${POSTGRES_DB}'"
)

if [[ -z "${database_exists}" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Create User ${POSTGRES_USER} ..."
    createuser "${POSTGRES_USER}"
    printf "\e[1;32m%-6s\e[m\n" "Create Database ${POSTGRES_DB} ..."
    createdb --owner "${POSTGRES_USER}" "${POSTGRES_DB}"
    printf "\e[1;32m%-6s\e[m\n" "Set User Password ..."
    psql --command "alter user ${POSTGRES_USER} with encrypted password '${POSTGRES_PASS}';"
    printf "\e[1;32m%-6s\e[m\n" "Grant User Privileges ..."
    psql --command "grant all privileges on database ${POSTGRES_DB} to ${POSTGRES_USER};"
fi
