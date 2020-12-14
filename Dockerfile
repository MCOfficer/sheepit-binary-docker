FROM nginx:1.19.5-alpine

RUN apk add wget

# Alpine doesn't execute cron scripts with extension, so this is just named "sync"
COPY sync.sh /usr/local/bin/sync-mirror

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
VOLUME [ "/data" ]

# the container's entrypoint will execute this script to start crond
RUN echo "crond -f -l 2 &" > /docker-entrypoint.d/crond.sh && chmod +x /docker-entrypoint.d/crond.sh
COPY crontab /etc/crontabs/root