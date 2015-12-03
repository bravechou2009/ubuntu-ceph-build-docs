======================
ubuntu-ceph-build-docs
======================
-----------------------------
An Adventure in Dockerization
-----------------------------

So you want to hack on the Ceph documentation. Here's how:

Install docker. Make sure the service is running and you are in the docker
group.

Clone this repo and cd in:
::
    $ git clone git://github.com/smithfarm/ubuntu-ceph-build-docs
    $ cd ubuntu-ceph-build-docs

Edit the Dockerfile. Change "smithfarm/ceph" and "wip-index" to your fork
and branch.

Build docker image:
::
    $ docker build -t ubuntu-ceph-build-docs .

Run container (not safe!):
::
    $ sudo docker run -d -p 80:80 --name cephdoc ubuntu-ceph-build-docs

Test that you can view the docs:
::
    $ curl http://localhost
    $ firefox http://localhost

Make changes to your fork and branch.

To rebuild the docs, go into the container:
::
    $ docker exec -it cephdoc bash
    root@f97749ede2ed:/#

The checkout is in /ceph, so:
::
    root@f97749ede2ed:/# cd ceph
    root@f97749ede2ed:/ceph# git pull
    root@f97749ede2ed:/ceph# admin/build-docs

Now view the docs again.

Repeat as necessary.

When you're done, stop the container:
::
    $ docker stop cephdoc

