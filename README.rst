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

Edit the Dockerfile. Change the following line so it points to **your**
fork and branch: ::

    RUN git clone -b wip-14070 git://github.com/smithfarm/ceph.git

If you don't have a fork, you can try building the master docs by changing
the line to: ::

    RUN git clone -b master git://github.com/ceph/ceph.git
    
Build docker image: ::

    $ docker build -t ubuntu-ceph-build-docs .

Run the container (16289 is the host port where the built documentation
will be accessible via HTTP - change it to whatever you like): ::

    $ docker run -d -p 16289:80 --name cephdoc ubuntu-ceph-build-docs

Test that you can view the docs: ::

    $ curl http://localhost:16289
    $ firefox http://localhost:16289

If you are working on the documentation, you can push modifications to the
WIP (Work In Progress) branch in your fork, and rebuild the docs to view
your changes. After you have pushed some new commits, go into the
container: ::

    $ docker exec -it cephdoc bash
    root@f97749ede2ed:/ceph#

Run :code:`git pull` to pull your updated wip branch: ::

    root@f97749ede2ed:/ceph# git pull

And run :code:`admin/build-docs` to rebuild the docs: ::

    root@f97749ede2ed:/ceph# admin/build-docs

Now reload your browser page. Repeat this process as many times you like
until your work is finished.

When you're done, stop the container: ::

    $ docker stop cephdoc

Or remove it completely: ::

    $ docker rm -f cephdoc

