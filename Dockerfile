# Set default values for build arguments
ARG DOCKERFILE_VERSION=1.0.0
ARG JNLP_VERSION=3.27-1

FROM jenkins/jnlp-slave:$JNLP_VERSION-alpine

USER root

# Add JenkinsCI user
# Create a dotnet user to run as
RUN addgroup -g 1000 jenkinsci \
    && adduser -u 1000 -G jenkinsci -s /bin/sh -D jenkinsci

# Install dependencies as root
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
    apk add --no-cache docker curl jq make py-pip python-dev libffi-dev openssl-dev gcc libc-dev make && \
    pip3 install --upgrade pip && \
    pip3 install cffi && \
    pip3 install docker-compose

USER jenkins

ENTRYPOINT ["jenkins-slave"]
