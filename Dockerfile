ARG target
FROM $target/golang:1.13-alpine as builder

WORKDIR /go/src/github.com/eko/pihole-exporter
COPY . .
COPY qemu-* /usr/bin/

ARG goarch
RUN apk update && \
    apk --upgrade --no-cache add git alpine-sdk gcc libc-dev

RUN GO111MODULE=on go mod vendor
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$goarch go build -ldflags '-s -w' -o binary ./

FROM $target/alpine

LABEL name="pihole-exporter"
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL \
  maintainer="Jesse Stuart <hi@jessestuart.com>" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.url="https://hub.docker.com/r/jessestuart/pihole-exporter" \
  org.label-schema.vcs-url="https://github.com/jessestuart/pihole-exporter" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

COPY --from=builder /go/src/github.com/eko/pihole-exporter/binary /pihole-exporter

ENTRYPOINT ["/pihole-exporter"]
