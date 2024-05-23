#!/bin/bash

set -e

source dev-container-features-test-lib

check "perl" perl --version

reportResults
