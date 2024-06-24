#!/bin/bash

NUM_CPUS=$(nproc)                           # Calculate the number of CPUs available
PROJ_NAME=${DJANGO_PROJ_NAME:-"config"}     # Name of the project, I usually use the same name for all my projects
RUN_PORT=${PORT:-8000}                      # Set the default port if not provided
NUM_WORKERS=$((NUM_CPUS * 2 + 1))

# Start Gunicorn server
gunicorn ${PROJ_NAME}.wsgi:application \
    --worker-class sync \
    --workers ${NUM_WORKERS} \
    --max-requests 1000 \
    --max-requests-jitter 50 \
    --timeout 60 \
    --preload \
    --bind 0.0.0.0:$RUN_PORT

# Use default synchronous workers
# Number of workers based on CPU count
# Max requests per worker before restarting
# Add jitter to max requests to avoid simultaneous restarts
# Timeout for handling a request
# Preload app before forking workers
# Bind to all IP addresses on the specified port