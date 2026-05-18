#!/bin/bash
# Run Schema App (PyQt GUI) locally
# Usage: ./run-schema-qt.sh
#
# This script runs the PyQt version of the schema app locally.
# Requires: Python 3.12+, uv, PyQt6

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DASH_GUI_DIR="${SCRIPT_DIR}/DASH_GUI"

echo "=========================================="
echo "Running Schema App (PyQt GUI)"
echo "=========================================="
echo ""
echo "Library path: ${SCRIPT_DIR}"
echo ""

cd "${DASH_GUI_DIR}"
uv run python run_schema_app.py
