FROM debian:bullseye-slim AS running

ENV VNC_HOST localhost
ENV VNC_PORT 5900
ENV PLAYER_ROOT http://localhost:8080

RUN apt-get update && apt-get -y --no-install-recommends install \
    python3=3.9.2-3 \
    sed=4.7-1\
    gstreamer1.0-tools=1.18.4-2.1 \
    gstreamer1.0-plugins-bad=1.18.4-3 \
    gstreamer1.0-plugins-ugly=1.18.4-2 \
    gstreamer1.0-plugins-good=1.18.4-2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

STOPSIGNAL SIGKILL
ENTRYPOINT [ "/run" ]
CMD []
COPY root /