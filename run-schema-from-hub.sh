#!/bin/bash
# Start Schema App using Docker Hub image
# Usage: ./run-schema-from-hub.sh [port]
#
# Opens the browser automatically once the app is ready.
# Press Ctrl+C to stop the app.

PORT=${1:-5000}
IMAGE="hapdocker/dash-gui:latest"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="dash-gui-schema-$$"
URL="http://localhost:$PORT"

echo "========================================="
echo "  DASH-GUI  |  Schema App"
echo "========================================="
echo "  Image: $IMAGE"
echo "  Port:  $PORT"
echo "  URL:   $URL"
echo "========================================="
echo ""

# Pull latest image
echo "Pulling latest image..."
if ! docker pull "$IMAGE"; then
    echo "ERROR: Failed to pull image. Is Docker running?"
    exit 1
fi
echo ""

# Stop container on Ctrl+C or script exit
cleanup() {
    echo ""
    echo "Stopping Schema App..."
    docker stop "$CONTAINER_NAME" >/dev/null 2>&1
    echo "Done. Goodbye!"
    exit 0
}
trap cleanup INT TERM

# Start container in background
echo "Starting Schema App..."
docker run -d \
    --rm \
    --name "$CONTAINER_NAME" \
    -p "$PORT:$PORT" \
    -v "$SCRIPT_DIR:/app/data" \
    -e APP=schema \
    -e PORT="$PORT" \
    -e SHARED_LIBRARIES_ROOT=/app/data \
    --user "$(id -u):$(id -g)" \
    "$IMAGE" >/dev/null

echo "Waiting for app to be ready..."
for i in $(seq 1 30); do
    if curl -sf "$URL" >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

echo ""
echo "========================================="
echo "  Schema App is running at: $URL"
echo "  Press Ctrl+C to stop."
echo "========================================="
echo ""

# Open browser (cross-platform)
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$URL" >/dev/null 2>&1 &
elif command -v open >/dev/null 2>&1; then
    open "$URL" &
fi

# Keep script alive so Ctrl+C works
while true; do
    sleep 1
done
