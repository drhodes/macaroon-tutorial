#!/bin/bash
set -e

echo "Building JupyterLite site..."
uv run jupyter lite build --contents content --output-dir dist
cp index.html dist/index.html

LAB_PATH=macaroon-tutorial

echo "Setting up local test environment..."
rm -rf _local_test
mkdir -p _local_test/$LAB_PATH

# Copy everything including hidden files from dist
cp -a dist/. _local_test/$LAB_PATH/

echo "================================================================"
echo "Serving local test site."
echo "Open your browser to: http://localhost:8000/$LAB_PATH/"
echo "Press Ctrl+C to stop."
echo "================================================================"

uv run python -m http.server 8000 -d _local_test
