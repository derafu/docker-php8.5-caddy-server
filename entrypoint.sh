#!/bin/bash
set -e

# Function to install or update Deployer.
deployer-install() {
    local dir="$1"

    # If the volume is empty, clone the repo.
    if [ ! -d "$dir/.git" ]; then
        echo "Deployer directory is empty. Cloning repository..."
        rm -f "$dir/.empty"
        git clone https://github.com/derafu/deployer.git "$dir"
    else
        git config --global --add safe.directory /home/admin/deployer
        echo "Deployer repository found. Pulling latest changes..."
        if ! git -C "$dir" pull; then
            echo "Warning: Git pull failed. There may be uncommitted changes."
        fi
    fi

    # Install dependencies.
    composer install --working-dir="$dir"
}

# Show the current user.
echo "Current user: $(whoami)"

# Install Deployer.
deployer-install "$DEPLOYER_DIR"

# Run the main process (by default supervisord).
exec "$@"
