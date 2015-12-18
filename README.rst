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

Build docker image: ::

    $ docker build -t ubuntu-ceph-build-docs .

Run the container (16289 is the host port where the built documentation
will be accessible via HTTP - change it to whatever you like): ::

    $ docker run -d -p 16289:80 --name cephdoc ubuntu-ceph-build-docs

This causes the :code:`runme.sh` script to be run with the defaults,
meaning that it will build the documentation from the upstream master
branch. If you would like to build from a different fork and/or branch,
append either or both of the following arguments to the end of the
:code:`docker run` command: ::

    --fork $GITHUB_USER
    --branch $BRANCH

E.g.: ::

    $ docker run -d -p 16289:80 --name cephdoc ubuntu-ceph-build-docs \
    --fork smithfarm \
    --branch wip-14070

This will start the container and run the :code:`runme.sh` script inside
it. Since the script clones the :code:`ceph.git` repo and builds the docs,
it takes time to complete. Use the following command to monitor progress: ::

    $ docker exec -it cephdoc tail -f runme.out

Once the script finishes, hit CTRL-C to return to your shell prompt. The
last thing the script does is run :code:`lighttpd` in the container. The
Ceph documentation that was just built can now be viewed. ::

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

