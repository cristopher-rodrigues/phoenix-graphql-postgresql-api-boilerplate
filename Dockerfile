FROM elixir:1.9.1-alpine as builder

RUN apk add --update --no-cache \
    curl curl-dev make g++ postgresql-client bash openssh git

RUN mix local.rebar --force && \
    mix local.hex --force

RUN apk add --update openssl

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix deps.get && \
  MIX_ENV=prod mix release --overwrite

FROM alpine:3.9

RUN apk add --update openssl bash libstdc++

EXPOSE 4000/tcp

WORKDIR /app/boilerplate
COPY --from=builder /app/_build/prod/ /app/boilerplate/
