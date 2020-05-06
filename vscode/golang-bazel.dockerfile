#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Spell checker
# cSpell: words cna jdk buildifier deps buildifier buildozer
# cSpell: ignore MPL

FROM cna0/vscode-development-container-golang:base

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

ARG BAZEL_BUILDTOOLS_VERSION=2.2.1

# Install Bazel
RUN curl -s https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - \
    && echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && apt-get update \
    && apt-get install -y bazel \
    #
    # Install Bazel-tools from https://github.com/bazelbuild/buildtools/releases
    && curl -Ls https://github.com/bazelbuild/buildtools/releases/download/${BAZEL_BUILDTOOLS_VERSION}/buildifier -o /usr/local/bin/buildifier \
    && chmod +x  /usr/local/bin/buildifier \
    #
    && curl -Ls https://github.com/bazelbuild/buildtools/releases/download/${BAZEL_BUILDTOOLS_VERSION}/buildozer -o /usr/local/bin/buildozer \
    && chmod +x  /usr/local/bin/buildozer \
    #
    && curl -Ls https://github.com/bazelbuild/buildtools/releases/download/${BAZEL_BUILDTOOLS_VERSION}/unused_deps -o /usr/local/bin/unused_deps \
    && chmod +x  /usr/local/bin/unused_deps \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
