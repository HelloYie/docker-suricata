FROM centos:7

RUN yum -y install epel-release yum-plugin-copr && \
    yum -y copr enable jasonish/suricata-stable && \
    yum -y install suricata

RUN yum -y install python-yaml

# Open up the permissions on /var/log/suricata so linked containers can
# see it.
RUN chmod 755 /var/log/suricata

COPY /docker-entrypoint.sh /

VOLUME /var/log/suricata

RUN /usr/sbin/suricata -V

# 添加规则
RUN suricata-update
RUN suricata-update enable-source et/open
RUN suricata-update enable-source ptresearch/attackdetection

ENTRYPOINT ["/docker-entrypoint.sh"]
