# Colab Local Runtime Launcher

## Overview
- `run.sh` starts the Colab runtime container (`us-docker.pkg.dev/colab-images/public/runtime`) with GPU support.
- It maps container port `8080` to a host port that is either:
  - Explicitly set via `PORT` in `.env`, or
  - Automatically selected between `8080-9000`.

## Prerequisites
- Docker installed with GPU access (NVIDIA Container Toolkit)  
- `.env` file (optional) with a line like `PORT=8088`

## Usage
1. (Optional) Edit `.env` to set `PORT`. If omitted, the script scans for a free port.
2. Run:
   ```bash
   ./run.sh
   ```
3. Watch the script output for the chosen host port, then connect to `http://127.0.0.1:<PORT>` in your browser when Colab prompts for the URL.

## Troubleshooting
- **Port already in use**: adjust `PORT` in `.env` or stop the conflicting service.
- **No free ports**: ensure at least one port in the `8080-9000` range is available.
- **Docker GPU errors**: verify `nvidia-smi` works on the host and Docker has GPU permissions.

