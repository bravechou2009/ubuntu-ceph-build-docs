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

Once you have the Docker image, run the container (16289 is the host port
where the built documentation will be accessible via HTTP - change it to
whatever you like): ::

    $ docker run -d -p 16289:80 --name cephdoc ubuntu-ceph-build-docs

The default is to build the documentation from the upstream master
branch. If you would like to build from an arbitrary fork and/or branch,
append either or both of the following arguments to the end of the
:code:`docker run` command: ::

    --fork $GITHUB_USER
    --branch $BRANCH

E.g.: ::

    $ docker run -d -p 16289:80 --name cephdoc ubuntu-ceph-build-docs \
    --fork smithfarm \
    --branch wip-14070

This will cause the Ceph fork at http://github.com/smithfarm/ceph.git to be
cloned and the documentation in the :code:`wip-14070` branch within that
fork to be built. 

Cloning a :code:`ceph.git` repo and building the docs does takes time to
complete. Use the following command to monitor progress: ::

    $ docker exec -it cephdoc tail -f runme.out

Once the script finishes, hit CTRL-C to return to your shell prompt. The
last thing the script does is run :code:`lighttpd` in the container. The
Ceph documentation that was just built can now be viewed on the port you
specified in the :code:`docker run` command, above: ::

    $ firefox http://localhost:16289

Support for incremental hacking
===============================

Now you can hack on the documentation and push incremental modifications to
the WIP (Work In Progress) branch in your fork. At any time, you can enter
the container, pull your changes, and rebuild the docs. The workflow looks
like this: ::

    $ git push
    $ docker exec -it cephdoc bash
    root@f97749ede2ed:/# cd ceph
    root@f97749ede2ed:/ceph# git pull
    root@f97749ede2ed:/ceph# admin/build-docs

Now reload your browser page. Repeat this process as many times you like
until your work is finished.

Cleanup
=======

When you're done, stop the container: ::

    $ docker stop cephdoc

Or remove it completely: ::

    $ docker rm -f cephdoc

