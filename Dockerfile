FROM debian:bullseye-slim AS s6
ARG S6_OVERLAY_VERSION=3.0.0.2

RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates=20210119 \
    wget=1.21-1+deb11u1 \
    xz-utils=5.2.5-2

RUN wget https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz &&\
    wget https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz &&\
    mkdir /s6 &&\
    tar -C /s6 -Jxpf s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz &&\
    tar -C /s6 -Jxpf s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz

FROM debian:bullseye-slim AS running

COPY --from=s6 /s6 /

RUN apt-get update && apt-get -y --no-install-recommends install \
    python3=3.9.2-3 \
    sed=4.7-1\
    gstreamer1.0-tools=1.18.4-2.1 \
    gstreamer1.0-plugins-bad=1.18.4-3 \
    gstreamer1.0-plugins-ugly=1.18.4-2 \
    gstreamer1.0-plugins-good=1.18.4-2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV VNC_HOST localhost
ENV VNC_PORT 5900
ENV PLAYER_ROOT http://localhost:8080

ENTRYPOINT [ "/init" ]
CMD []
COPY root /