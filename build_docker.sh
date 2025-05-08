#!/bin/bash

# Define the Docker image name
IMAGE_NAME="jmfederico/wormhole"

# Define target platforms
PLATFORMS="linux/amd64,linux/arm64"

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

echo "Building multi-platform Docker image ${IMAGE_NAME} for platforms: ${PLATFORMS}..."
echo "The images will be loaded into the local Docker daemon."
echo "Using Dockerfile: ./${DOCKERFILE_PATH}"
echo "Using build context: ${BUILD_CONTEXT}"
echo "INFO: Ensure your Docker buildx builder is set up (e.g., run 'docker buildx create --use mybuilder' and 'docker buildx inspect mybuilder --bootstrap')."

# Build the Docker image for multiple platforms and load it into the local Docker daemon
# --platform: Specify the target platforms
# --load: Load the multi-platform images into the local Docker daemon (useful for local testing)
#         For pushing directly to a registry, you would typically use --push instead of --load.
# -t: Tag for the image (name:tag)
# -f: Path to the Dockerfile
# BUILD_CONTEXT: The build context path
docker buildx build --platform "${PLATFORMS}" --load -t "${IMAGE_NAME}" -f "${DOCKERFILE_PATH}" "${BUILD_CONTEXT}"

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Multi-platform Docker image ${IMAGE_NAME} built and loaded successfully for platforms: ${PLATFORMS}."
    echo "To push this multi-platform image to a registry, you would typically re-run with --push instead of --load:"
    echo "Example: docker buildx build --platform \"${PLATFORMS}\" --push -t \"${IMAGE_NAME}\" -f \"${DOCKERFILE_PATH}\" \"${BUILD_CONTEXT}\""
else
    echo "Error: Multi-platform Docker image build failed."
    exit 1
fi