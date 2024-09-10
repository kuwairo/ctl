# alpine:3.20.3
FROM docker.io/library/alpine@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

ARG BIN_DIR="/usr/local/bin"
ARG BIN_USER="ctl"

ARG KUBECTL_VERSION="v1.30.4"
ARG HELM_VERSION="v3.15.4"
ARG TALOSCTL_VERSION="v1.7.6"

RUN temp="$(mktemp -d)" && \
    cd "$temp" && \
    wget https://dl.k8s.io/${KUBECTL_VERSION}/kubernetes-client-linux-amd64.tar.gz && \
    tar xf kubernetes-client-linux-amd64.tar.gz && \
    mv kubernetes/client/bin/* ${BIN_DIR}/ && \
    wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm ${BIN_DIR}/ && \
    wget https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-amd64 && \
    mv talosctl-linux-amd64 ${BIN_DIR}/talosctl && \
    cd - && \
    rm -rf "$temp"

RUN adduser -u 1000 -s /bin/sh -D ${BIN_USER}
USER ${BIN_USER}
WORKDIR /home/${BIN_USER}

CMD ["sh"]
