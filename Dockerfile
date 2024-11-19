FROM dockerhub.paypalcorp.com/golang:1.22-bullseye AS builder

ENV GOPROXY=https://artifactory.g.devqa.gcp.dev.paypalinc.com/artifactory/api/go/go
WORKDIR /go/src/github.com/paypal/load-watcher
COPY . .
RUN make build

FROM alpine:3.12

COPY --from=0 /go/src/github.com/paypal/load-watcher/bin/load-watcher /bin/load-watcher

CMD ["/bin/load-watcher"]
