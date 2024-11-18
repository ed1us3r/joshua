#!/bin/env bash
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" 
# Get current stable kubectl version via curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${ARCH}/kubectl"

# Verfiy
# get sha checksum
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${ARCH}/kubectl.sha256"
# compare
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
# install it
if [ $? == 0 ]; then
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi


# get krew
set -x; cd "$(mktemp -d)" &&
KREW="krew-${OS}_${ARCH}" &&
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
tar zxvf "${KREW}.tar.gz" &&
./"${KREW}" install krew

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

kubectl-krew install flame
kubectl-krew install cnpg
kubectl-krew install tree
kubectl-krew install ctx
kubectl-krew install ns
