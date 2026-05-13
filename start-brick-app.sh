#!/bin/bash
# Start Brick App using Docker Hub image
# Usage: ./start-brick-app.sh [port]

PORT=${1:-5001}
IMAGE="hapdocker/dash-gui:latest"

echo "Starting Brick App from Docker Hub..."
echo "  Image: $IMAGE"
echo "  Port: $PORT"
echo "  URL: http://localhost:$PORT"
echo ""

# Pull latest image
echo "Pulling latest image..."
docker pull "$IMAGE"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Mounting shared_libraries from: $SCRIPT_DIR"
echo ""

# Run container
docker run -it \
    --rm \
    -p "$PORT:$PORT" \
    -v "$SCRIPT_DIR:/app/data" \
    -e APP=brick \
    -e PORT="$PORT" \
    --user "$(id -u):$(id -g)" \
    "$IMAGE"
