# Magic Wormhole (Rust) Docker Image

This repository contains a `Dockerfile` to build a Docker image for `magic-wormhole.rs`, a Rust implementation of Magic Wormhole.

Magic Wormhole allows you to get arbitrary-sized files and directories (or short pieces of text) from one computer to another.

## Prerequisites

- Docker installed on your system.

## Building the Image

There are two ways to build the Docker image:

### 1. Using Docker command (manual, single-platform)

This method builds an image for your current machine's architecture only.

Navigate to the directory containing the `Dockerfile` (the root of this repository) and run:

```sh
docker build -t jmfederico/wormhole .
```
For multi-platform builds, refer to the "Using the build script" section below.

### 2. Using the build script (for Multi-Platform Images)

This repository includes a helper script `build_docker.sh` to build multi-platform images (currently `linux/amd64` and `linux/arm64`) using `docker buildx`.

**Prerequisites for `buildx`:**
- Ensure `docker buildx` is available.
- You need a `buildx` builder instance that supports multi-platform builds. If you haven't configured one, you might need to create and use one:
  ```sh
  # Example: Create and switch to a new builder
  docker buildx create --name mymultibuilder --use
  docker buildx inspect mymultibuilder --bootstrap
  ```
  The `build_docker.sh` script will use the builder `buildx` is currently configured to use.

**Building and Loading Locally:**

First, make the script executable:
```sh
chmod +x build_docker.sh
```

Then, run the script from the `magic-wormhole` directory (the root of this repository):
```sh
./build_docker.sh
```
This script will build the image for the specified platforms (e.g., `linux/amd64`, `linux/arm64`) with the tag `jmfederico/wormhole` and **load** the resulting images into your local Docker daemon. This is useful for local testing of the image for your host's architecture. The script will also inform you about the command to push to a registry.

**Pushing the Multi-Platform Image to a Registry:**

The `build_docker.sh` script (which uses `docker buildx build --load ...`) is primarily for local builds. To create and push a multi-platform manifest list and its associated images to a container registry like Docker Hub, you need to run `docker buildx build` with the `--push` flag.

1.  **Log in to your Docker registry:**
    ```sh
    docker login
    ```
    (Or `docker login your.registry.com` if using a private registry).

2.  **Build and push:**
    After potentially building locally with `./build_docker.sh`, you can push using a command like the one shown by the script upon its successful completion, or directly:
    ```sh
    docker buildx build --platform linux/amd64,linux/arm64 --push -t jmfederico/wormhole -f Dockerfile .
    ```
    - `--platform linux/amd64,linux/arm64`: Specifies the target architectures. Ensure this matches the platforms your `build_docker.sh` script is configured for if you are relying on its output.
    - `--push`: Pushes the built images and manifest list to the registry.
    - `-t jmfederico/wormhole`: The tag for your image.
    - `-f Dockerfile .`: Specifies the Dockerfile and the build context (repository root).

This command will build the images for each specified platform and then push them along with a manifest list. The manifest list allows Docker clients to automatically pull the correct image for their architecture.

## Using the Image

The image uses `wormhole-rs` as its entrypoint.

### Using the `run_wormhole.sh` script (Recommended)

This repository includes a helper script `run_wormhole.sh` which simplifies running the Docker container. It automatically:
- Mounts your current working directory to `/data` inside the container.
- Runs the container with your current user's ID and group ID to avoid permission issues with files created in the mounted volume.
- Passes any arguments directly to the `wormhole-rs` command.

First, make the script executable:
```sh
chmod +x run_wormhole.sh
```

**Note on PATH usage:** For easier access, you can move or copy `run_wormhole.sh` to a directory in your system's `PATH` (e.g., `~/.local/bin` or `/usr/local/bin` on Linux/macOS). If you do this, you can run it from any directory like any other command (e.g., `run_wormhole.sh send my_file.txt`). The script is designed to:
- Always use your **current working directory** (i.e., the directory from which you invoke the command) for mounting to `/data` in the container.
- Run the container with **your current user's ID and group ID**, ensuring correct file permissions.

This behavior remains consistent even when the script is executed from a location in your `PATH`.

#### Sending a File

To send a file from your current directory:

```sh
./run_wormhole.sh send your_file_name.ext
```
Replace `your_file_name.ext` with the actual name of the file you want to send. The command will output a wormhole code.

#### Sending Text

To send a short piece of text:

```sh
./run_wormhole.sh send --text "your message here"
```

#### Receiving a File or Text

To receive a file or text using a wormhole code:

```sh
./run_wormhole.sh receive <WORMHOLE_CODE>
```
Replace `<WORMHOLE_CODE>` with the code you received from the sender. If it's a file, it will be saved in your current directory. If it's text, it will be printed to the console.

#### Listing Available Commands

To see all available commands and options for `wormhole-rs` using the script:

```sh
./run_wormhole.sh --help
```

Or for a specific subcommand like `send`:

```sh
./run_wormhole.sh send --help
```

### Using `docker run` command (Manual)

If you prefer not to use the `run_wormhole.sh` script, you can run the container manually. The working directory inside the container is `/data`. It's recommended to mount a local directory to `/data` to easily send files from your host or receive files to your host.

#### Sending a File

To send a file from your current directory:

```sh
# On Linux/macOS
docker run -it --rm -v "$(pwd):/data" --user "$(id -u):$(id -g)" jmfederico/wormhole send your_file_name.ext

# On Windows (PowerShell)
docker run -it --rm -v "${PWD}:/data" jmfederico/wormhole send your_file_name.ext
```
Note: The `--user` flag helps with file permissions on Linux/macOS.

Replace `your_file_name.ext` with the actual name of the file you want to send. The command will output a wormhole code.

#### Sending Text

To send a short piece of text:

```sh
docker run -it --rm jmfederico/wormhole send --text "your message here"
```

#### Receiving a File or Text

To receive a file or text using a wormhole code:

```sh
# On Linux/macOS
docker run -it --rm -v "$(pwd):/data" --user "$(id -u):$(id -g)" jmfederico/wormhole receive <WORMHOLE_CODE>

# On Windows (PowerShell)
docker run -it --rm -v "${PWD}:/data" jmfederico/wormhole receive <WORMHOLE_CODE>
```
Replace `<WORMHOLE_CODE>` with the code you received from the sender. If it's a file, it will be saved in your current directory. If it's text, it will be printed to the console.

#### Listing Available Commands

To see all available commands and options for `wormhole-rs`:

```sh
docker run -it --rm jmfederico/wormhole --help
```

Or for a specific subcommand like `send`:

```sh
docker run -it --rm jmfederico/wormhole send --help
```
