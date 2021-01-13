FROM nginx:1.19.5-alpine

RUN apk add wget

# Alpine doesn't execute cron scripts with extension, so this is just named "sync"
COPY sync.sh /usr/local/bin/sync-mirror

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
VOLUME [ "/data" ]

# the container's entrypoint will execute these scripts to start crond and the initial sync
RUN echo "crond -f -l 2 &" > /docker-entrypoint.d/crond.sh
COPY crontab /etc/crontabs/root

RUN echo "sync-mirror &" > /docker-entrypoint.d/initial.sh

RUN chmod +x /docker-entrypoint.d/*
