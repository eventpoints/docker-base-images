FROM caddy:builder-alpine as builder

RUN xcaddy build \
	--with github.com/dunglas/mercure \
	--with github.com/dunglas/mercure/caddy

FROM caddy:builder-alpine AS caddy

WORKDIR /app

COPY --from=dunglas/mercure:v0.11 /srv/public /srv/mercure-assets/
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
