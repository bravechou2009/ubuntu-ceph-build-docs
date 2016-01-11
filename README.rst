======================
ubuntu-ceph-build-docs
======================
------------------------------------------------------------------
Dockerized environment for building and viewing Ceph documentation
------------------------------------------------------------------

This README describes how to use :code:`ubuntu-ceph-build-docs` to

* clone the :code:`ceph.git` GitHub repository from an arbitrary fork and branch
* build the Ceph documentation
* start :code:`lighttpd` to serve the built documentation

all in semi-automated fashion. Since everything takes place in a
self-contained Docker container

* the builds are repeatable 
* the build artifacts do not clutter your system
* you don't have to worry about build dependencies: these are taken care of
  within the Docker image

Preparation
===========

Install Docker. Make sure the service is running and you are in the
:code:`docker` group.

The easiest way to obtain this software is to pull the Docker image from
Docker Hub: ::

    $ docker pull smithfarm/ubuntu-ceph-build-docs:latest

If that is not appropriate for some reason, you will have to clone this
repo and build the image yourself: ::

    $ git clone git://github.com/smithfarm/ubuntu-ceph-build-docs
    $ cd ubuntu-ceph-build-docs
    $ docker build -t ubuntu-ceph-build-docs .

Running the container
=====================

Once you have the Docker image, run the container inside your local clone
of the Ceph source code. Use the following command: ::

    $ docker run --rm -it \
      $(w=$(git rev-parse --show-toplevel 2>/dev/null) && echo "-v $w:$w -w $w") \
      --env USER_ID=$(id -u) --env USER_NAME=$(id -un) \
      ubuntu-ceph-build-docs

If all goes well, the documentation will be built inside the
:code:`build-doc/output/html/` directory and the script will output a
:code:`file://` URI that you can paste into your browser to view the
documentation. Alternatively, you can start a simple webserver in that
directory using a command like this:

    $ cd build-doc/output/html/
    $ python -m SimpleHTTPServer 5000

And then point your browser at `http://localhost:5000`.

Tips
====

The :code:`docker run` command above is long and complicated. However, it
can easily be made into an alias or a function. The file
:code:`review-docs.sh` illustrates one way to accomplish this.

