#! /usr/bin/env bash

set +e

_image() {
  docker build . -t builder -f bin/builder.Dockerfile && \
  docker run -v "$(pwd)/":/app --rm builder bin/build.sh release && \
  docker build . -t app -f bin/run.Dockerfile
}

_release() {
  # set build ENV
  export MIX_ENV=prod

  # # install hex + rebar
  # mix local.hex --force && mix local.rebar --force

  # install mix dependencies
  mix deps.get
  mix deps.compile

  # build project
  mix compile

  # build release
  mix release --overwrite --path ./export
}

case $1 in
  image ) _image ;;
  release ) _release ;;
esac
