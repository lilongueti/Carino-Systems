#!/bin/bash

# Define variables
APPIMAGE_URL=$1
APPIMAGE_NAME=$2
INSTALL_PATH="/usr/bin/$APPIMAGE_NAME"

# Download the AppImage
echo "Downloading AppImage..."
wget -O "$APPIMAGE_NAME" "$APPIMAGE_URL"

# Verify download success
if [ ! -f "$APPIMAGE_NAME" ]; then
    echo "Download failed. Exiting."
    exit 1
fi

# Make the AppImage executable
chmod +x "$APPIMAGE_NAME"

# Move the AppImage to a system path
echo "Installing AppImage..."
sudo mv "$APPIMAGE_NAME" "$INSTALL_PATH"

# Optional: Integrate the AppImage into the system
# This step may require additional tools or steps depending on the AppImage

echo "Installation Complete"
