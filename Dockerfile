FROM alpine:3.10

MAINTAINER badmikko

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key \
    MINIO_KMS_MASTER_KEY_FILE=kms_master_key \
    MINIO_SSE_MASTER_KEY_FILE=sse_master_key

RUN \
  apk add --no-cache ca-certificates 'curl>7.61.0' 'su-exec>=0.2' && \
  curl https://dl.min.io/server/minio/release/linux-arm64/minio > /usr/bin/minio && \
  curl https://dl.min.io/client/mc/release/linux-arm64/mc > /usr/bin/mc && \
  curl https://github.com/minio/minio/raw/master/dockerscripts/docker-entrypoint.sh > /usr/bin/docker-entrypoint.sh && \
  chmod +x /usr/bin/minio /usr/bin/mc /usr/bin/docker-entrypoint.sh && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

CMD ["minio"]
