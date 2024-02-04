#!/bin/bash

# Add Espanso's repository
echo "Adding Espanso repository..."
sudo dnf copr enable alebastr/espanso -y

# Install Espanso
echo "Installing Espanso..."
sudo dnf install espanso -y

# Start Espanso service
echo "Starting Espanso..."
systemctl --user enable --now espanso

echo "Installation complete. You may need to log out and log back in for Espanso to start working."
