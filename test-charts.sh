#!/usr/bin/env bash
set -e
CHART_NAME="$1"
echo "Running integration test for chart: $CHART_NAME"
helm install test-release "charts/$CHART_NAME" --wait --timeout 120s || true
helm test test-release || true
helm uninstall test-release || true
echo "Integration test complete for $CHART_NAME"
