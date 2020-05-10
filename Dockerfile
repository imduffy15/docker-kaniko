FROM debian:buster-slim

ENV DOCKER_CREDENTIAL_GCR_CONFIG=/kaniko/.config/gcloud/docker_credential_gcr_config.json
ENV PATH="/kaniko:${PATH}"
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG=/kaniko/.docker/

COPY --from=gcr.io/kaniko-project/executor:debug /kaniko /kaniko
