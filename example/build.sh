#!/usr/bin/env bash
set -euo pipefail

docker compose run --rm typst compile letter.typ
echo "Done: letter.pdf"
