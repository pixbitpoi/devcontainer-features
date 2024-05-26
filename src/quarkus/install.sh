#!/bin/bash

set -e

JAVA_VERSION=${JDKVERSION}
MAVEN_VERSION=${MAVENVERSION}
QUARKUS_VERSION=${QUARKUSVERSION}
USERNAME="vscode"

# 選択範囲を変数に格納
SCRIPT=$(cat <<EOF
# Install sdkman
curl -sSL "https://get.sdkman.io" | bash
source /home/${USERNAME}/.sdkman/bin/sdkman-init.sh

# Install java and maven
sdk install java ${JAVA_VERSION}
sdk install maven ${MAVEN_VERSION}
sdk install quarkus ${QUARKUS_VERSION}

# Flush
sdk flush archives
sdk flush temp

# Create local maven repository folder
mkdir -p /home/${USERNAME}/.m2/repository
EOF
)

# 変数の中身を実行
echo "$SCRIPT" | sudo -u $USERNAME bash