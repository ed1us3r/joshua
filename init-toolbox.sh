#!/bin/env bash

# Provide the cosign.pub Key

# Set desired name via CLI argument, but default to "joshua"
name="${1:-joshua}"

# mark old images for deletion
for dir in joshua-*/ ; do 
    [ -L "{dir%/}" ] && continue
    echo "[INIT]>>>>>: Preparing to pull possile joshua releases for: ${dir///}"
    echo "[INIT]>>>>>: Cleaning existing image and container(s) from toolbox if any exist. Currently procesing ${dir///}"
    image="${dir///}"
    # Uncomment if limited space available
    # toolbox rmi $image --force
    cd $(dirname "${BASH_SOURCE[0]}")
    podman run -v ./cosign.pub:/tmp/cosign.pub \
        -it  docker.io/bitnami/cosign \
        verify --key /tmp/cosign.pub \
        ghcr.io/ed1us3r/${image}:latest
    rc=$?
    if [ $rc = 0 ]; then 
        echo "[VERIFY]>>: Verify has passed. Now pull the signed image: ${image} and store locally."
        podman pull "ghcr.io/ed1us3r/${image}:latest"
        echo "[Tooolbox]: Creating toolbox"
        toolbox create -i "ghcr.io/ed1us3r/${image}" "${image}"
    else 
        echo "[ERROR]>>>: Verification seemes to have failed."
        
        # Implement pubkey auto curl and verify against it
        #pubkey=`curl `
        
        #rc=$?
        exit 2 
    fi
done