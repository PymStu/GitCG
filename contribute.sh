#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/.contribute.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

cd "$SCRIPT_DIR"

COMMIT_COUNT=$((RANDOM % 5 + 3))

log "Starting: will make $COMMIT_COUNT commits"

for i in $(seq 1 "$COMMIT_COUNT"); do
    DELAY=$((RANDOM % 600 + 60))
    sleep "$DELAY"

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    RANDOM_HASH=$(head -c 8 /dev/urandom | md5sum | head -c 8)

    echo "$TIMESTAMP $RANDOM_HASH" >> contributions.txt

    git add contributions.txt
    git commit -m "update: $TIMESTAMP [$RANDOM_HASH]" --quiet

    log "Commit $i/$COMMIT_COUNT done at $TIMESTAMP"
done

git push origin master --quiet
log "Pushed $COMMIT_COUNT commits to remote"

echo "" > contributions.txt
git add contributions.txt
git commit -m "reset: clean contributions" --quiet
git push origin master --quiet
log "Reset contributions.txt"
