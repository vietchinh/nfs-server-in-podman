ARG FEDORA_VERSION

FROM registry.fedoraproject.org/fedora:${FEDORA_VERSION}
MAINTAINER vietchinh

ARG PACKAGE_VERSION

RUN mkdir -p /var/lib/nfs/ && \
    useradd auser

RUN dnf install systemd nfs-utils-${PACKAGE_VERSION} dnf-automatic --setopt=install_weak_deps=False --nodocs -y && \
    dnf clean all

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable rpcbind nfs-server; systemctl enable dnf-automatic-install.timer

CMD ["/sbin/init"]