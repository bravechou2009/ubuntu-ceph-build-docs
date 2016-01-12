FROM ubuntu:14.04
MAINTAINER Nathan Cutler <presnypreklad@gmail.com>

# nova.clouds.archive.ubuntu.com is faster
RUN sed -i -e 's|http://archive.ubuntu|http://nova.clouds.archive.ubuntu|' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

# install latest updates and the required packages
RUN apt-get -y update && apt-get --yes install \
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
    cython \
    librbd-dev

# fix ditaa packaging mishap
RUN rm /usr/bin/ditaa
COPY ditaa.sh /usr/bin/ditaa
RUN chmod 755 /usr/bin/ditaa

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
