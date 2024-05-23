#!/bin/bash

# This test file will be executed against the scenario defined in scenario.json
# that includes the 'perl' feature with "version": "5.32.0" option.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "Perl version" perl -v | grep "v5.24.3"

# Report results
reportResults