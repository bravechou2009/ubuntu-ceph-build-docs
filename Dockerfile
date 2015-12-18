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

# configure lighty
RUN mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.ORIG
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
EXPOSE 80

# hand over to runme.sh
COPY runme.sh /tmp/runme.sh
RUN install -o root -g root -m 755 /tmp/runme.sh /runme.sh
ENTRYPOINT [ "/runme.sh" ]
