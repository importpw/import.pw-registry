FROM alpine:3.5 AS base
ARG REGISTRY_AUTH_USERNAME
ARG REGISTRY_AUTH_PASSWORD
ARG S3_ACCESS_KEY
ARG S3_SECRET_KEY
ARG S3_BUCKET
ARG S3_REGION
WORKDIR /usr/src
RUN apk add --no-cache m4 apache2-utils

# Create the `htpasswd` file for basic auth
RUN echo "$REGISTRY_AUTH_PASSWORD" | htpasswd -B -i -c htpasswd "$REGISTRY_AUTH_USERNAME"

# Fill out the S3 placeholders in the config.yml file
COPY config.yml config.template.yml
RUN cat config.template.yml | m4 \
  --define S3_ACCESS_KEY="$S3_ACCESS_KEY" \
  --define S3_SECRET_KEY="$S3_SECRET_KEY" \
  --define S3_REGION="$S3_REGION" \
  --define S3_BUCKET="$S3_BUCKET" > config.yml

FROM registry:2.6
COPY --from=base /usr/src/config.yml /etc/docker/registry/config.yml
COPY --from=base /usr/src/htpasswd /etc/htpasswd
