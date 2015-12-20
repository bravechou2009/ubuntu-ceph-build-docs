#!/bin/bash
#
# review-docs.sh
#
# Defines a convenient function for running the Docker image. To be sourced, i.e.:
#
# $ source review-docs.sh
# $ review-docs

function review-docs() {
    docker run --rm -it \
        $(w=$(git rev-parse --show-toplevel 2>/dev/null) && echo "-v $w:$w -w $w") \
        --env USER_ID=$(id -u) --env USER_NAME=$(id -un) \
        ubuntu-ceph-build-docs
}
