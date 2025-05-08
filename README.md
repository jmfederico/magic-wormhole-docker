# Magic Wormhole (Rust) Docker Image

This repository contains a `Dockerfile` to build a Docker image for `magic-wormhole.rs`, a Rust implementation of Magic Wormhole.

Magic Wormhole allows you to get arbitrary-sized files and directories (or short pieces of text) from one computer to another.

## Prerequisites

- Docker installed on your system.

## Building the Image

There are two ways to build the Docker image:

### 1. Using Docker command (manual)

Navigate to the directory containing the `Dockerfile` (the root of this repository) and run:

```sh
docker build -t jmfederico/wormhole .
```

### 2. Using the build script

This repository includes a helper script `build_docker.sh` to build the image.

First, make the script executable:
```sh
chmod +x build_docker.sh
```

Then, run the script from the `magic-wormhole` directory (the root of this repository):
```sh
./build_docker.sh
```
This script will build the image with the tag `jmfederico/wormhole`.

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
