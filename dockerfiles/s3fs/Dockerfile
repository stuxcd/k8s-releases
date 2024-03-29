########################################################
# The FUSE driver needs elevated privileges, run Docker with --privileged=true
# or with minimum elevation as shown below:
# $ sudo docker run -d --rm --name s3fs --security-opt apparmor:unconfined \
#  --cap-add mknod --cap-add sys_admin --device=/dev/fuse
########################################################

FROM ubuntu:14.04

ENV DUMB_INIT_VER 1.2.2
ENV S3_BUCKET ''
ENV MNT_POINT /mnt
ENV S3_ENDPOINT ''
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update --fix-missing && \
    apt-get install -y automake autotools-dev g++ git libcurl4-gnutls-dev wget \
                       libfuse-dev libssl-dev libxml2-dev make pkg-config psmisc && \
    git clone https://github.com/s3fs-fuse/s3fs-fuse.git /tmp/s3fs-fuse && \
    cd /tmp/s3fs-fuse && ./autogen.sh && ./configure && make && make install && \
    ldconfig && /usr/local/bin/s3fs --version && \
    wget -O /tmp/dumb-init_${DUMB_INIT_VER}_amd64.deb https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VER}/dumb-init_${DUMB_INIT_VER}_amd64.deb && \
    dpkg -i /tmp/dumb-init_*.deb

RUN echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > /etc/passwd-s3fs && \
    chmod 0400 /etc/passwd-s3fs

RUN mkdir -p "$MNT_POINT"

RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y wget automake autotools-dev g++ git make && \
    apt-get -y autoremove --purge && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD run.sh /app/run.sh
RUN chmod +x /app/run.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--", "bash", "-c", "/app/run.sh"]
