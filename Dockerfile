# Mono doesn't have jammy yet (as at 24/07/2023 so has to use focal #
ARG FRM='ubuntu:focal'
ARG TAG='latest'
ARG DEBIAN_FRONTEND='noninteractive'

FROM ${FRM}
ARG FRM
ARG TAG
ARG TARGETPLATFORM

## build note ##
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM}" >> /build.info

## Install basic packages ##
RUN apt -y update \
    && apt -y upgrade \
    && apt -y dist-upgrade \
    && apt -y install bash nano procps tini \
    && apt -y install curl unzip jq \
    && apt -y install tar \
    && apt -y remove hddtemp \
    && apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

## install static codes ##
RUN rm -Rf /testdasi \
    && mkdir -p /temp \
    && cd /temp \
    && curl -sL "https://github.com/testdasi/static-ubuntu/archive/main.zip" -o /temp/temp.zip \
    && unzip /temp/temp.zip \
    && rm -f /temp/temp.zip \
    && mv /temp/static-ubuntu-main /testdasi \
    && rm -Rf /testdasi/deprecated

## execute execute execute ##
RUN /bin/bash /testdasi/scripts-install/install-mono.sh

## debug mode ##
#RUN /bin/bash /testdasi/scripts-install/install-debug-mode.sh
#ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

## Final clean up ##
RUN rm -Rf /testdasi
