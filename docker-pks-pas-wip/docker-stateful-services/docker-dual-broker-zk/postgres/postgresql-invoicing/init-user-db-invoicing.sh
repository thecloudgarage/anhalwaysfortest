#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE dbinvoicing;
    GRANT ALL PRIVILEGES ON DATABASE dbinvoicing TO dbuser;
EOSQL
