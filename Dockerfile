FROM registry:2.6
ARG S3_ACCESS_KEY
ARG S3_SECRET_KEY
ARG S3_BUCKET
ARG S3_REGION
RUN apk add --no-cache m4
WORKDIR /etc/docker/registry
COPY config.yml config.template.yml
RUN cat config.template.yml | m4 \
  --define S3_ACCESS_KEY="$S3_ACCESS_KEY" \
  --define S3_SECRET_KEY="$S3_SECRET_KEY" \
  --define S3_REGION="$S3_REGION" \
  --define S3_BUCKET="$S3_BUCKET" > config.yml && apk del --no-cache m4
