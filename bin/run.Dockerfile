FROM alpine:3.15.0 AS app
RUN apk add --no-cache --update bash openssl libgcc libstdc++

WORKDIR /app

RUN chown nobody:nobody /app
USER nobody:nobody

COPY --chown=nobody:nobody export ./

ENV HOME=/app

CMD /app/bin/a start
