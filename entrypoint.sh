#!/bin/bash
#
# runme.sh
#
# Docker entrypoint script for "ceph-workbench review-docs"
#

adduser --disabled-password --gecos ReviewDocs --quiet --uid $USER_ID $USER_NAME
sudo --set-home --preserve-env --user $USER_NAME admin/build-doc
echo "Point browser to: $(pwd)/build-doc/output/html/index.html"
