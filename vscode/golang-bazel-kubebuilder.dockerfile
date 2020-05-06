#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Spell checker
# cSpell: words cna kubebuilder kustomize CLI xenial tmp gotools MPL etcd sigs
# cSpell: ignore xz

FROM cna0/vscode-development-container-golang:bazel

ARG kubebuilder_version=2.3.1
ARG kustomize_version=3.3.0
ARG os=linux
ARG arch=amd64

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
# For testing mostly
ENV KUBEBUILDER_ASSETS=/usr/local/bin

RUN \
    # Install Kubernetes CLI
    #
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    #
    # Install kubebuilder binaries
    #
    && curl -L https://go.kubebuilder.io/dl/${kubebuilder_version}/${os}/${arch} | tar -xz -C /tmp/ \
    && mv /tmp/kubebuilder_${kubebuilder_version}_${os}_${arch}/bin/kubebuilder /usr/local/bin/kubebuilder \
    && mv /tmp/kubebuilder_${kubebuilder_version}_${os}_${arch}/bin/etcd /usr/local/bin/etcd \
    && mv /tmp/kubebuilder_${kubebuilder_version}_${os}_${arch}/bin/kube-apiserver /usr/local/bin/kube-apiserver \
    #
    # Install kustomize
    #
    && GOPATH=/tmp/gotools GO111MODULE=on go get sigs.k8s.io/kustomize/kustomize/v3@v${kustomize_version} 2>&1 \
    && mv /tmp/gotools/bin/* /usr/local/bin/ \
    #
    # Clean up
    #
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/kubebuilder_${kubebuilder_version}_${os}_${arch} /tmp/gotools

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
