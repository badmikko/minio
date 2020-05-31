FROM alpine:3.10

MAINTAINER badmikko

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key \
    MINIO_KMS_MASTER_KEY_FILE=kms_master_key \
    MINIO_SSE_MASTER_KEY_FILE=sse_master_key

RUN \
  dpkgArch="$(uname -m)" && \
  && case "${dpkgArch##*-}" in \
    x86_64) ARCH='amd64';; \
    aarch64) ARCH='arm64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  echo “Running on ${ARCH}” && \
  apk add --no-cache ca-certificates 'curl>7.61.0' 'su-exec>=0.2' && \
  curl -o /usr/bin/minio https://dl.min.io/server/minio/release/linux-${ARCH}/minio && \
  curl -o /usr/bin/mc https://dl.min.io/client/mc/release/linux-${ARCH}/mc && \
  curl -o /usr/bin/docker-entrypoint.sh https://github.com/minio/minio/raw/master/dockerscripts/docker-entrypoint.sh && \
  chmod +x /usr/bin/minio /usr/bin/mc /usr/bin/docker-entrypoint.sh && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

CMD ["minio"]
