FROM ubuntu:14.04
MAINTAINER Nathan Cutler <presnypreklad@gmail.com>

RUN sed -i -e 's|http://archive.ubuntu|http://nova.clouds.archive.ubuntu|' /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install git python-dev python-pip python-virtualenv libxml2-dev libxslt-dev doxygen ditaa graphviz ant lighttpd librbd1
RUN rm /usr/bin/ditaa
ADD ditaa.sh /usr/bin/ditaa
RUN chmod 755 /usr/bin/ditaa
RUN git clone git://github.com/smithfarm/ceph
RUN cd ceph
RUN /ceph/admin/build-doc
RUN mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.ORIG
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
EXPOSE 80
CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf
