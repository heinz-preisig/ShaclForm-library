#!/bin/bash
# Start Schema App using Docker Hub image
# Usage: ./start-schema-app.sh [port]

PORT=${1:-5000}
IMAGE="hapdocker/dash-gui:latest"

echo "Starting Schema App from Docker Hub..."
echo "  Image: $IMAGE"
echo "  Port: $PORT"
echo "  URL: http://localhost:$PORT"
echo ""

# Pull latest image
echo "Pulling latest image..."
docker pull "$IMAGE"

echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Mounting shared_libraries from: $SCRIPT_DIR"
echo ""

# Run container
docker run -it \
    --rm \
    -p "$PORT:$PORT" \
    -v "$SCRIPT_DIR:/app/data" \
    -e APP=schema \
    -e PORT="$PORT" \
    --user "$(id -u):$(id -g)" \
    "$IMAGE"
