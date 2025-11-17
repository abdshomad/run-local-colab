# Reference: https://research.google.com/colaboratory/local-runtimes.html

#!/usr/bin/env bash
set -euo pipefail

START_PORT=8080
END_PORT=9000
CONTAINER_PORT=8080
IMAGE="us-docker.pkg.dev/colab-images/public/runtime"

port_in_use() {
  ss -H -ltn sport = :"$1" | grep -q .
}

read_port_from_env() {
  local env_file=".env"
  [[ -f "${env_file}" ]] || return 1

  local value
  value="$(sed -n 's/^[[:space:]]*PORT[[:space:]]*=[[:space:]]*//p' "${env_file}" | tail -n1)"
  value="${value%%#*}"
  value="$(echo -n "${value}" | tr -d '\"' | xargs || true)"

  if [[ -n "${value}" ]]; then
    echo "${value}"
    return 0
  fi

  return 1
}

find_available_port() {
  for ((port=START_PORT; port<=END_PORT; port++)); do
    if port_in_use "${port}"; then
      continue
    fi
    echo "$port"
    return 0
  done
  return 1
}

HOST_PORT="$(read_port_from_env || true)"

if [[ -n "${HOST_PORT}" ]]; then
  if [[ ! "${HOST_PORT}" =~ ^[0-9]+$ ]]; then
    echo "Invalid PORT value '${HOST_PORT}' in .env" >&2
    exit 1
  fi
  if port_in_use "${HOST_PORT}"; then
    echo "Port ${HOST_PORT} from .env is already in use." >&2
    echo "Stop the conflicting service or update .env before rerunning." >&2
    exit 1
  fi
else
  HOST_PORT="$(find_available_port)" || {
    echo "No available ports between ${START_PORT}-${END_PORT}" >&2
    exit 1
  }
fi

echo "Using host port ${HOST_PORT}"

docker run --gpus=all -p "127.0.0.1:${HOST_PORT}:${CONTAINER_PORT}" "${IMAGE}"
