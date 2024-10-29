#!/bin/sh

# Define the base directory for Matterbridge
HOME_DIR=/config

# Define the subdirectories for Matterbridge
MATTERBRIDGE_PLUGINS=$HOME_DIR/Matterbridge   # For matterbridge plugins

# Create directories if they don't exist
mkdir -p $MATTERBRIDGE_PLUGINS

echo "Copying matterbridge-zigbee2mqtt..."
cp -r /matterbridge-zigbee2mqtt $MATTERBRIDGE_PLUGINS/
