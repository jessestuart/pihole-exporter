#!/bin/sh

echo '
export GITHUB_REPO=eko/pihole-exporter
export GOPATH=/go
export GOROOT=/usr/local/go
export IMAGE=pihole-exporter
export REGISTRY=jessestuart

export VERSION=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases/latest | jq -r ".tag_name")
export IMAGE_ID="${REGISTRY}/${IMAGE}:${VERSION}-${TAG}"
export DIR=`pwd`
export QEMU_VERSION="v4.0.0"
' >>$BASH_ENV

. $BASH_ENV
