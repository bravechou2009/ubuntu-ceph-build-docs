======================
ubuntu-ceph-build-docs
======================
------------------------------------------------------
Dockerized environment for building Ceph documentation
------------------------------------------------------

So you want to hack on the Ceph documentation. Here's how:

Learn about reStructuredText:

* `reStructuredText Primer`_
* `reStructuredText Documentation`_
* `reStructuredText Markup Specification`_

.. _`reStructuredText Primer`: http://sphinx-doc.org/rest.html
.. _`reStructuredText Documentation`: 
   http://docutils.sourceforge.net/rst.html
.. _`reStructuredText Markup Specification`:
   docutils.sourceforge.net/docs/ref/rst/restructuredtext.html

Install docker. Make sure the service is running and you are in the docker
group.

Fork the `ceph/ceph` project on GitHub.

Clone this repo and cd in: ::

    $ git clone git://github.com/smithfarm/ubuntu-ceph-build-docs
    $ cd ubuntu-ceph-build-docs

Edit the Dockerfile. Change "smithfarm/ceph" to your fork.

Build docker image: ::

    $ docker build -t ubuntu-ceph-build-docs .

Run container (not safe!): ::

    $ sudo docker run -d -p 80:80 --name cephdoc ubuntu-ceph-build-docs

Test that you can view the docs: ::

    $ curl http://localhost
    $ firefox http://localhost

Make changes to your fork.

To rebuild the docs, go into the container: ::

    $ docker exec -it cephdoc bash
    root@f97749ede2ed:/#

The checkout is in /ceph, so: ::

    root@f97749ede2ed:/# cd ceph
    root@f97749ede2ed:/ceph# git pull
    root@f97749ede2ed:/ceph# admin/build-docs

Now view the docs again.

Repeat as necessary.

When you're done, stop the container: ::

    $ docker stop cephdoc

