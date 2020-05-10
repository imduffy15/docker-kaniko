FROM python:3.7-slim-buster

COPY --from=gcr.io/kaniko-project/executor:debug /kaniko/executor /usr/bin/executor
COPY --from=gcr.io/kaniko-project/executor:debug /kaniko/warmer /usr/bin/warmer

RUN rm -rf /bin/sh && \
    ln -s /bin/bash /bin/sh

RUN pip install --upgrade pip awscli

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

ENV GCLOUD_VERSION=290.0.0

RUN curl -f -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz | tar xzv && \
    mv google-cloud-sdk /opt && \
    /opt/google-cloud-sdk/bin/gcloud components install docker-credential-gcr && \
    ln -sf /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud && \
    ln -sf /opt/google-cloud-sdk/bin/gsutil /usr/bin/gsutil && \
    ln -sf /opt/google-cloud-sdk/bin/docker-credential-gcr /usr/bin/docker-credential-gcr && \
    ln -sf /opt/google-cloud-sdk/bin/docker-credential-gcloud /usr/bin/docker-credential-gcloud

ENV HELM_VERSION=2.16.7

RUN curl -f https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz  | tar xzv && \
    mv linux-amd64/helm /usr/bin/ && \
    rm -rf linux-amd64

ENV YQ_VERSION=3.3.0

RUN curl -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/bin/

COPY entrypoint.sh /entrypoint

ENTRYPOINT /entrypoint
