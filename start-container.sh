#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ENTRYPOINT='--entrypoint="/launch.sh"'

if [ "$1" == "setup" ]; then
  IMAGE_VERSION="setup"
  OPTS="it -e RUN_SETUP=1"
else
  IMAGE_VERSION="latest"
  OPTS="dit"
fi

# Check if we want to load in data from a backup volume
if [ -e "$1" ]; then
  VOLUMES=`$DIR/backup.py -g $1`
  echo "Running with attached volumes: $VOLUMES"
  echo
else
  VOLUMES=""
fi

# Run the docker instance!
IMAGE_NAME='froxlor'
docker run -$OPTS $ENTRYPOINT \
  -p 80:80 -p 443:443 -p :21 \
  $VOLUMES \
  $IMAGE_NAME:$IMAGE_VERSION

# Finish setup
if [ "$1" == "setup" ]; then
  SETUP_CONTAINER=`docker ps -a | grep -m 1 "$IMAGE_NAME:$IMAGE_VERSION" | awk '{print $1;}'`

  echo "Tagging $SETUP_CONTAINER as latest"
  docker commit $SETUP_CONTAINER $IMAGE_NAME:latest

  # echo "Tagging $SETUP_CONTAINER as $VER"
  # docker commit $SETUP_CONTAINER $IMAGE_NAME:$VER

  echo "Setup complete."
  echo "  Navigate to http://localhost/froxlor for next step of installation."
  echo ""
fi
