FROM ubuntu:20.04

RUN apt-get update && apt-get install -y ca-certificates file && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY rupx /app/rupx
COPY rupayamainnet.json /app/rupayamainnet.json

RUN ls -l /app && \
    file /app/rupx && \
    chmod +x /app/rupx && \
    ldd /app/rupx || true && \
    echo "Attempting to run rupx..." && \
    /app/rupx version || echo "Failed to run rupx"

EXPOSE 8545 8546 30303 30303/udp

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]