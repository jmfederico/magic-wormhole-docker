#!/bin/bash

# Get the directory from which the script is being run
HOST_DIR="$(pwd)"

# Get the current user's UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Define the Docker image name
# Ensure you have built the image with this tag, e.g.,
# docker build -t jmfederico/wormhole -f Dockerfile .
IMAGE_NAME="jmfederico/wormhole"

# Check if any arguments were passed to the script
if [ $# -eq 0 ]; then
    echo "Usage: $0 <wormhole arguments>"
    echo "Example: $0 send my_file.txt"
    exit 1
fi

# Run the Docker container
# --rm: Automatically remove the container when it exits
# -v: Mount the host directory to /data in the container
# --user: Run the command inside the container with the specified UID:GID
# "${IMAGE_NAME}": The name of the Docker image to use
# "$@": Pass all script arguments to the container's entrypoint (wormhole)
docker run -ti --rm \
    -v "${HOST_DIR}":/data \
    --user "${USER_ID}:${GROUP_ID}" \
    "${IMAGE_NAME}" "$@"
