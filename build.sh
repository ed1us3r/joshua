#!/bin/env bash

# Set desired name via CLI argument, but default to "toolbox"
name="${1:-joshua}"

# mark old images for deletion
for dir in joshua-*/ ; do 
    [ -L "{dir%/}" ] && continue
    echo "Preparing to build possile joshua releases for: ${dir///}"
    echo "Cleaning existing image and container(s) from toolbox if any exist. Currently procesing ${dir///}"
    image="${dir///}"
    toolbox rmi $image --force
    cd $(dirname "${BASH_SOURCE[0]}")
    if [ -e ./$image/Containerfile ]; then
        echo "Building base image"
        podman build -t $image -f ./$image/Containerfile

        echo "Creating toolbox"
        toolbox create -i "$image" "$image"
    fi
done

