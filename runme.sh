#!/bin/bash
#
# runme.sh
#
# Docker entrypoint script for "ceph-workbench review-docs"
#

OUT=./runme.out

# define usage_exit function
usage_exit() {
    echo "usage: $0 [options]"
    echo "Options:"
    echo "\t--help / -h    Show this usage message"
    echo "\t--fork / -f    GitHub username with fork of ceph/ceph.git"
    echo "\t--branch / -b  Name of branch (in user's fork) to build from"
    exit
}

# parse the options
OPTS=$(getopt -n 'runme.sh' -o 'hf:b:' -l 'help,fork:,branch:' -- "$@")
if [ $? != 0 ] ; then
    exit 1
fi
eval set -- "$OPTS"
FORK=ceph
BRANCH=master
while echo $1 | grep -q '^-'; do
    case $1 in
        -h | --help)
            usage_exit
            ;;
        -f | --fork)
            shift
            FORK=$1
            ;;
        -b | --branch)
            shift
            BRANCH=$1
            ;;
        --)
            shift
            break
            ;;
        *)
            echo unrecognized option \'$1\'
            usage_exit
            ;;
    esac
    shift
done

# clone the repo, build the docs
echo "Cloning http://github.com/$FORK/ceph.git, branch $BRANCH" 2>&1 | tee $OUT
git clone --progress -b $BRANCH http://github.com/$FORK/ceph.git 2>&1 | tee -a $OUT
( cd ceph ; exec admin/build-doc ) 2>&1  | tee -a $OUT

# start lighty
lighttpd -D -f /etc/lighttpd/lighttpd.conf 2>&1 | tee -a $OUT
