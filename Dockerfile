FROM ubuntu:14.04
MAINTAINER Nathan Cutler <presnypreklad@gmail.com>

# nova.clouds.archive.ubuntu.com is faster
RUN sed -i -e 's|http://archive.ubuntu|http://nova.clouds.archive.ubuntu|' /etc/apt/sources.list

# install latest updates
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# install admin/build-doc dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install \
    git \
    python-dev \
    python-pip \
    python-virtualenv \
    libxml2-dev \
    libxslt-dev \
    doxygen \
    ditaa \
    graphviz \
    ant \
    lighttpd \
    python-ceph

# fix ditaa packaging mishap
RUN rm /usr/bin/ditaa
COPY ditaa.sh /usr/bin/ditaa
RUN chmod 755 /usr/bin/ditaa

# clone the "smithfarm" repo (replace this with your fork)
RUN git clone git://github.com/smithfarm/ceph.git
RUN cd ceph

# add the official ceph repo as a remote, and fetch
RUN git remote add ceph https://github.com/ceph/ceph.git
RUN git fetch ceph
RUN git merge ceph/master

# build the docs
RUN /ceph/admin/build-doc

# configure and run lighty
RUN mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.ORIG
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
EXPOSE 80

CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf
