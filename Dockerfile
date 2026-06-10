ARG BUILD_SPEC="build.amd64"
# Builder
FROM golang:1.22

COPY paypal-crypto-root-ca.crt /usr/local/share/ca-certificates/paypal-crypto-root-ca.crt

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates git \
 && update-ca-certificates

ENV GOPROXY=direct

WORKDIR /go/src/github.com/paypal/load-watcher
COPY . .
RUN make ${BUILD_SPEC}

# Runtime
FROM alpine:3.12

RUN apk add --no-cache ca-certificates && update-ca-certificates

COPY --from=0 /go/src/github.com/paypal/load-watcher/bin/load-watcher /bin/load-watcher

CMD ["/bin/load-watcher"]
