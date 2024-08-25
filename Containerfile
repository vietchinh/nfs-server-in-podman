ARG FEDORA_VERSION

FROM ghcr.io/vietchinh/fedora-minimal-init:${FEDORA_VERSION}
MAINTAINER vietchinh

ARG PACKAGE_VERSION

RUN mkdir -p /var/lib/nfs/ && \
    useradd auser

RUN microdnf install nfs-utils-${PACKAGE_VERSION} --setopt=install_weak_deps=False --nodocs -y && \
    microdnf clean all && \
    systemctl enable rpcbind nfs-server

CMD ["/sbin/init"]
