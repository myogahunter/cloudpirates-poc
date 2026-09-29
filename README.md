# cloudpirates-poc

Replica of CloudPirates-io/helm-charts CI workflow.

Demonstrates fork checkout + test script execution:
- `pull_request_target` triggers on any fork PR (no gate)
- Fork code is checked out as the working directory
- Docker Hub login happens with REGISTRY_USER/REGISTRY_PASSWORD
- `./test-charts.sh` runs from the fork workspace — attacker-controlled
- Docker creds are in ~/.docker/config.json at execution time

Used for authorized security research only.
