#!/usr/bin/env bash
# Run commands inside the dev container.
# Usage: ./dev.sh <command> [args...]
# Examples:
#   ./dev.sh hugo version
#   ./dev.sh hugo -s blog server --bind 0.0.0.0

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

devcontainer up --workspace-folder "$REPO_ROOT" > /dev/null
devcontainer exec --workspace-folder "$REPO_ROOT" "$@"
