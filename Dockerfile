FROM python:3.12.3-alpine as ansible-lint

LABEL maintainer="András Barabás <barabasandras1@gmail.com>"

RUN apk add --no-cache git==2.43.0-r0 \
  && apk add --no-cache --virtual \
  .build-deps \
  make==4.4.1-r2 \
  gcc==13.2.1_git20231014-r0 \
  libc-dev==0.7.2-r5 \
  libffi-dev==3.4.4-r3 \
  openssl-dev==3.1.4-r6 \
  && pip install --no-cache-dir ansible-lint==24.2.3

WORKDIR /work

CMD ["ansible-lint"]

# Makefile lint: build
FROM golang:1.22.2 as makefile-lint-build

ARG BUILDER_NAME
ARG BUILDER_EMAIL

ENV GOOS=linux GOARCH=amd64 CGO_ENABLED=0

RUN git clone https://github.com/mrtazz/checkmake.git /go/src/github.com/mrtazz/checkmake

WORKDIR /go/src/github.com/mrtazz/checkmake

RUN make binaries \
  && make test

# Makefile lint: run
FROM alpine:3.19.1 as makefile-lint

RUN apk add --no-cache make==4.4.1-r2

USER nobody

COPY --from=makefile-lint-build /go/src/github.com/mrtazz/checkmake/checkmake /

ENTRYPOINT ["./checkmake", "/Makefile"]
