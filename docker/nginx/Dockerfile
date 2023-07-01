FROM nginx:1.19.0-alpine
ENV TZ=UTC

# Install ls
RUN apk add --no-cache coreutils

# nginx config file
COPY ./docker/nginx/*.conf /etc/nginx/conf.d/

WORKDIR /var/www/html
