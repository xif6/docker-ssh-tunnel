FROM alpine:3.9
MAINTAINER François PASINI <francois.pasini@gmail.com>

RUN apk add --update openssh-client && rm -rf /var/cache/apk/*

RUN date

ADD tunnel.sh /opt/tunnel.sh
CMD /opt/tunnel.sh

