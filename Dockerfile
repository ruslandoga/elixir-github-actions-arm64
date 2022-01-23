FROM hexpm/elixir:1.13.1-erlang-24.2-alpine-3.15.0 as build

# install build dependencies
RUN apk add --no-cache --update build-base

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config/config.exs config/
RUN mix deps.get
RUN mix deps.compile

# build project
COPY lib lib
RUN mix compile
COPY config/runtime.exs config/

# build release
RUN mix release

# prepare release image
FROM alpine:3.15.0 AS app
RUN apk add --no-cache --update bash openssl libgcc libstdc++

WORKDIR /app

RUN chown nobody:nobody /app
USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/a ./

ENV HOME=/app

CMD /app/bin/a start
