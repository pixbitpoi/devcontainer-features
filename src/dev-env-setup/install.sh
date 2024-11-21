#!/usr/bin/env bash

set -e

USERNAME="vscode"
DEBIAN_FRONTEND="noninteractive"

# Add repositories
add_repositories() {
    ARCH=$(dpkg --print-architecture)
    RELEASE=$(lsb_release -cs)
    KEYPATH="/usr/share/keyrings"

    # eza
    echo "deb [arch=${ARCH} signed-by=${KEYPATH}/gierens.gpg] http://deb.gierens.de stable main" > /etc/apt/sources.list.d/gierens.list
    curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o "${KEYPATH}/gierens.gpg"

    # postgres
    echo "deb [arch=${ARCH} signed-by=${KEYPATH}/apt.postgresql.org.gpg] http://apt.postgresql.org/pub/repos/apt ${RELEASE}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o "${KEYPATH}/apt.postgresql.org.gpg"
}

# Install packages
install_packages() {
    apt-get update

    # libraries
    apt-get install -y --no-install-recommends --fix-missing \
        build-essential make llvm libffi-dev \
        libncursesw5-dev libreadline-dev libssl-dev tk-dev \
        libbz2-dev liblzma-dev zlib1g-dev \
        libxml2-dev libxmlsec1-dev \
        libpq-dev libmysqlclient-dev libsqlite3-dev libdb-dev \
        libjpeg-dev libpng-dev libgif-dev libwebp-dev libfreetype-dev

    # tools
    apt-get install -y --no-install-recommends --fix-missing \
        dnsutils iputils-ping exuberant-ctags xz-utils \
        tree jq eza tldr bat \
        mysql-client postgresql-client-16 sqlite3
}

# Setup locale
setup_locale() {
    locale-gen en_US.UTF-8 ja_JP.UTF-8
    echo "LANG=en_US.UTF-8" > /etc/default/locale
    echo "LANGUAGE=en_US:en" >> /etc/default/locale
    echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
}

# Setup vscode/cursor directories
setup_vscode_directories() {
    mkdir -p /home/$USERNAME/.vscode-server/extensions
    mkdir -p /home/$USERNAME/.vscode-server-insiders/extensions
    mkdir -p /home/$USERNAME/.cursor-server/extensions
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.vscode-server
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.vscode-server-insiders
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.cursor-server
}

# Install mailpit
install_mailpit() {
    VERSION="1.18.0"
    DOWNLOAD_URL="https://github.com/axllent/mailpit/releases/download/v${VERSION}/mailpit-linux-arm64.tar.gz"
    SMTP_ADDRESS="mail:1025"

    cd /home/$USERNAME
    curl -LO "$DOWNLOAD_URL"
    mkdir -p /home/$USERNAME/.local/bin
    tar -xzf mailpit-linux-arm64.tar.gz -C /home/$USERNAME/.local/bin/ mailpit
    rm mailpit-linux-arm64.tar.gz

    # Create alias for sendmail
    cat << EOF > /home/$USERNAME/.local/bin/sendmail
#!/bin/bash
exec /home/$USERNAME/.local/bin/mailpit sendmail -S "$SMTP_ADDRESS" "\$@"
EOF

    chmod +x /home/$USERNAME/.local/bin/mailpit
    chmod +x /home/$USERNAME/.local/bin/sendmail
    chown -R $USERNAME:$USERNAME /home/$USERNAME
}

# Main
add_repositories
install_packages
setup_locale
setup_vscode_directories
install_mailpit
