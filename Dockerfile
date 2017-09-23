FROM alpine:3.6

MAINTAINER Ed Sweeney <ed@onextent.com>

ARG GLIBC_VERSION=2.25-r0
ARG CONCOURSE_VERSION=3.5.0

RUN mkdir -p /opt/concourse && \
    addgroup -S concourse && \
    adduser -SDh /opt/concourse -s /sbin/nologin -G concourse concourse

RUN apk --no-cache add --update su-exec openssl dumb-init openssh-client bash findutils iptables

RUN TMPFILE=$(mktemp).apk KEYPATH=/etc/apk/keys/ PUBKEY=sgerrand.rsa.pub && \
    wget -q -P "${KEYPATH}" "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${PUBKEY}" && \
    wget -q -O "${TMPFILE}" "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    apk --no-cache add --update "${TMPFILE}" && \
    rm -rf "${TMPFILE}" "${KEYPATH}${PUBKEY}"

RUN apk --no-cache add --update dpkg && ARCH=$(dpkg --print-architecture | awk -F- '{ print $NF }') && apk del dpkg && \
    wget -q -O /usr/local/bin/concourse "https://github.com/concourse/concourse/releases/download/v${CONCOURSE_VERSION}/concourse_linux_${ARCH}" && \
    chown root:concourse /usr/local/bin/concourse && \
    chmod 1750 /usr/local/bin/concourse 

WORKDIR /opt/concourse

ADD mkkeys.sh /

RUN /mkkeys.sh && chown -R concourse:concourse /opt/concourse && chown -R concourse:concourse /concourse-keys

ENTRYPOINT ["/usr/bin/dumb-init", "su-exec", "concourse:concourse", "/usr/local/bin/concourse"]

