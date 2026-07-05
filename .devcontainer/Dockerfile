FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/*

ARG GO_VERSION=1.26.4
ARG HUGO_VERSION=0.163.3

# Install Go.
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz" \
    | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Hugo extended.
RUN curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-$(dpkg --print-architecture).deb" \
    -o /tmp/hugo.deb \
    && dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb
