#!/bin/sh
IMAGE=blang/latex:ctanfull
exec docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$PWD":/data "$IMAGE" "$@"
