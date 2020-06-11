# Set default values for build arguments
ARG DOCKERFILE_VERSION=1.0.0
ARG AGENT_VERSION=4.3-4

FROM jenkins/inbound-agent:$AGENT_VERSION-alpine

USER root

# Install dependencies as root
RUN apk add --no-cache python3-dev && \
    apk add --no-cache --virtual .build-deps libffi-dev openssl-dev gcc libc-dev make && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir docker-compose && \
    apk del .build-deps

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.18.3"
# Note: Latest version of helm may be found at
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.2.3"
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    apk add --no-cache docker-cli --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/community && \
    apk add --no-cache curl jq

USER jenkins

ENTRYPOINT ["jenkins-agent"]