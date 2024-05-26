#!/bin/bash

set -e

source dev-container-features-test-lib

check "java" java -version
check "maven" mvn -version
check "quarkus" quarkus --version

reportResults
