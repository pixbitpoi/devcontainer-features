#!/bin/bash

set -e

source dev-container-features-test-lib

check "postgres client" psql --version
check "mysql client" mysql --version
check "sqlite3 version" sqlite3 --version

reportResults
