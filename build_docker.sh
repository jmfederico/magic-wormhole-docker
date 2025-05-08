#!/bin/bash

# Define the Docker image name
IMAGE_NAME="jmfederico/wormhole"

# Define the path to the Dockerfile
# This script (magic-wormhole/build_docker.sh) now assumes it is run
# from WITHIN the "magic-wormhole" directory.
DOCKERFILE_PATH="Dockerfile"

# Define the build context (the directory containing the Dockerfile and any other needed files)
# This path is also relative to where the script is executed from.
# "." means the current directory.
BUILD_CONTEXT="."

# Check if the Dockerfile exists
if [ ! -f "${DOCKERFILE_PATH}" ]; then
    echo "Error: Dockerfile not found at ./${DOCKERFILE_PATH}"
    echo "Please ensure this script is run from within the 'magic-wormhole' directory, and the Dockerfile is present there."
    exit 1
fi

echo "Building Docker image ${IMAGE_NAME}..."
echo "Using Dockerfile: ./${DOCKERFILE_PATH}"
echo "Using build context: ${BUILD_CONTEXT}"

# Build the Docker image
# -t: Tag for the image (name:tag)
# -f: Path to the Dockerfile
# BUILD_CONTEXT: The build context path
docker build -t "${IMAGE_NAME}" -f "${DOCKERFILE_PATH}" "${BUILD_CONTEXT}"

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image ${IMAGE_NAME} built successfully."
else
    echo "Error: Docker image build failed."
    exit 1
fi