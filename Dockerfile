FROM ubuntu:14.04
MAINTAINER Nathan Cutler <presnypreklad@gmail.com>

# nova.clouds.archive.ubuntu.com is faster
RUN sed -i -e 's|http://archive.ubuntu|http://nova.clouds.archive.ubuntu|' /etc/apt/sources.list

# install latest updates
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# install basic admin/build-doc dependencies
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
    lighttpd

# install additional admin/build-doc dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install \
    cython \
    librbd-dev

# fix ditaa packaging mishap
RUN rm /usr/bin/ditaa
COPY ditaa.sh /usr/bin/ditaa
RUN chmod 755 /usr/bin/ditaa

# clone the "smithfarm" repo (edit to use YOUR fork and branch)
RUN git clone -b wip-14070 git://github.com/smithfarm/ceph.git

# build the docs
WORKDIR /ceph
RUN admin/build-doc

# configure and run lighty
RUN mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.ORIG
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
EXPOSE 80

CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf
