FROM hexpm/elixir:1.13.1-erlang-24.2-alpine-3.15.0

# install build dependencies
RUN apk add --no-cache --update build-base bash

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# prepare build dir
RUN mkdir /app
WORKDIR /app
