#!/bin/bash -e

REDIS_URL=$(cd /etc/pulp && python3 -c "from settings import REDIS_URL; print(REDIS_URL)")
echo "Using REDIS_URL: $REDIS_URL"
WORKER_NAME=${WORKER_NAME:-"worker@%h"}
rq worker --url "$REDIS_URL" -n "$WORKER_NAME" -w 'pulpcore.tasking.worker.PulpWorker' --disable-job-desc-logging
