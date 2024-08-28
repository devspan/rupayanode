FROM ubuntu:20.04

RUN apt-get update && apt-get install -y ca-certificates file && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY rupx /app/rupx
COPY rupayamainnet.json /app/rupayamainnet.json
COPY start.sh /app/start.sh

RUN chmod +x /app/rupx /app/start.sh

EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["/app/start.sh"]