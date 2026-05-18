#!/bin/bash
# Run Brick App (PyQt GUI) locally
# Usage: ./run-brick-qt.sh
#
# This script runs the PyQt version of the brick app locally.
# Requires: Python 3.12+, uv, PyQt6

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DASH_GUI_DIR="${SCRIPT_DIR}/DASH_GUI"

echo "=========================================="
echo "Running Brick App (PyQt GUI)"
echo "=========================================="
echo ""
echo "Library path: ${SCRIPT_DIR}"
echo ""

cd "${DASH_GUI_DIR}"
uv run python run_brick_app_qt.py
