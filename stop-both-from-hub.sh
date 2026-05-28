#!/bin/bash
# Stop both running DASH-GUI Docker containers from Docker Hub
# Usage: ./stop-both-from-hub.sh [container1] [container2]
#
# If no container names provided, attempts to read from /tmp/dash-gui-hub-containers.txt

if [ $# -ge 2 ]; then
    SCHEMA_CONTAINER="$1"
    BRICK_CONTAINER="$2"
else
    # Try to read from saved file
    if [ -f /tmp/dash-gui-hub-containers.txt ]; then
        read -r SCHEMA_CONTAINER _ BRICK_CONTAINER < /tmp/dash-gui-hub-containers.txt
        echo "Found saved container names: $SCHEMA_CONTAINER, $BRICK_CONTAINER"
    else
        echo "No container names provided and no saved state found."
        echo "Usage: ./stop-both-from-hub.sh <schema-container> <brick-container>"
        echo ""
        echo "Running containers:"
        docker ps --filter "name=dash-gui" --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
        exit 1
    fi
fi

echo "Stopping containers..."

if docker stop "$SCHEMA_CONTAINER" >/dev/null 2>&1; then
    echo "✓ Stopped $SCHEMA_CONTAINER"
else
    echo "⚠ $SCHEMA_CONTAINER not found or already stopped"
fi

if docker stop "$BRICK_CONTAINER" >/dev/null 2>&1; then
    echo "✓ Stopped $BRICK_CONTAINER"
else
    echo "⚠ $BRICK_CONTAINER not found or already stopped"
fi

# Clean up saved file
rm -f /tmp/dash-gui-hub-containers.txt

echo ""
echo "Done!"
