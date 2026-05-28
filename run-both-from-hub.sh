#!/bin/bash
# Start both Schema and Brick Apps from Docker Hub simultaneously
# Usage: ./run-both-from-hub.sh [schema_port] [brick_port]
#
# Examples:
#   ./run-both-from-hub.sh                    # Defaults: schema 5000, brick 5001
#   ./run-both-from-hub.sh 5000 5001          # Custom ports

SCHEMA_PORT=${1:-5000}
BRICK_PORT=${2:-5001}
IMAGE="hapdocker/dash-gui:latest"

echo "========================================="
echo "Starting Both Apps from Docker Hub"
echo "========================================="
echo ""
echo "Image:   $IMAGE"
echo ""
echo "Schema App:"
echo "  Port:  $SCHEMA_PORT"
echo "  URL:   http://localhost:$SCHEMA_PORT"
echo ""
echo "Brick App:"
echo "  Port:  $BRICK_PORT"
echo "  URL:   http://localhost:$BRICK_PORT"
echo ""
echo "========================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pull latest image
echo "Pulling latest image..."
if ! docker pull "$IMAGE"; then
    echo "✗ Failed to pull image"
    exit 1
fi
echo "✓ Image ready"
echo ""

# Generate unique container names with timestamp
TIMESTAMP=$(date +%s)
SCHEMA_CONTAINER="dash-gui-schema-${TIMESTAMP}"
BRICK_CONTAINER="dash-gui-brick-${TIMESTAMP}"

echo "Starting containers..."
echo "Mounting shared_libraries from: $SCRIPT_DIR"
echo ""

# Start Schema container in background
docker run -d \
    --rm \
    --name "$SCHEMA_CONTAINER" \
    -p "$SCHEMA_PORT:$SCHEMA_PORT" \
    -v "$SCRIPT_DIR:/app/data" \
    -e APP=schema \
    -e PORT="$SCHEMA_PORT" \
    -e SHARED_LIBRARIES_ROOT=/app/data \
    --user "$(id -u):$(id -g)" \
    "$IMAGE" >/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Schema app started (container: $SCHEMA_CONTAINER)"
else
    echo "✗ Failed to start Schema app"
    exit 1
fi

# Start Brick container in background
docker run -d \
    --rm \
    --name "$BRICK_CONTAINER" \
    -p "$BRICK_PORT:$BRICK_PORT" \
    -v "$SCRIPT_DIR:/app/data" \
    -e APP=brick \
    -e PORT="$BRICK_PORT" \
    -e SHARED_LIBRARIES_ROOT=/app/data \
    --user "$(id -u):$(id -g)" \
    "$IMAGE" >/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Brick app started (container: $BRICK_CONTAINER)"
else
    echo "✗ Failed to start Brick app"
    echo "Stopping Schema container..."
    docker stop "$SCHEMA_CONTAINER" >/dev/null 2>&1
    exit 1
fi

echo ""
echo "========================================="
echo "Both apps are running!"
echo "========================================="
echo ""
echo "Access URLs:"
echo "  Schema App: http://localhost:$SCHEMA_PORT"
echo "  Brick App:  http://localhost:$BRICK_PORT"
echo ""
echo "Container names:"
echo "  Schema: $SCHEMA_CONTAINER"
echo "  Brick:  $BRICK_CONTAINER"
echo ""
echo "To stop both containers:"
echo "  docker stop $SCHEMA_CONTAINER $BRICK_CONTAINER"
echo ""
echo "Or run: ./stop-both-from-hub.sh"
echo ""

# Save container names to file for easy stopping
echo "$SCHEMA_CONTAINER $BRICK_PORT $BRICK_CONTAINER" > /tmp/dash-gui-hub-containers.txt
echo "(Container info saved to /tmp/dash-gui-hub-containers.txt)"
