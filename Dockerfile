FROM ubuntu:latest

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install git python-dev python-pip python-virtualenv libxml2-dev libxslt-dev doxygen ditaa graphviz ant lighttpd
RUN rm /usr/bin/ditaa
ADD ditaa.sh /usr/bin/ditaa
RUN chmod 755 /usr/bin/ditaa
RUN git clone git://github.com/smithfarm/ceph
RUN cd ceph ; git checkout --track origin/wip-index
RUN /ceph/admin/build-doc
ADD basic.css /ceph/build-doc/output/html/_static/basic.css
ADD nature.css /ceph/build-doc/output/html/_static/nature.css
ADD pygments.css /ceph/build-doc/output/html/_static/pygments.css
RUN mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.ORIG
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
EXPOSE 80
CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf
