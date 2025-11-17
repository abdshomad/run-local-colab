#!/usr/bin/env bash
set -euo pipefail

IMAGE="us-docker.pkg.dev/colab-images/public/runtime"

mapfile -t containers < <(docker ps -q --filter "ancestor=${IMAGE}")

if [[ ${#containers[@]} -eq 0 ]]; then
  echo "No running containers found for image ${IMAGE}."
  exit 0
fi

for cid in "${containers[@]}"; do
  echo "Stopping container ${cid}..."
  docker stop "${cid}" >/dev/null
done

echo "Stopped ${#containers[@]} container(s)."

