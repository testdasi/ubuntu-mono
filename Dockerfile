ARG FRM='testdasi/ubuntu-base'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

# install static codes
RUN mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/testdasi/static-ubuntu/archive/main.zip" -o /temp/temp.zip \
    && unzip /temp/temp.zip \
    && rm -f /temp/temp.zip \
    && mv /temp/static-ubuntu-main /testdasi \
    && rm -Rf /testdasi/deprecated

# execute execute execute
RUN /bin/bash /testdasi/scripts-install/install-mono.sh

# build note
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info

# debug mode (comment to disable)
RUN cp /testdasi/scripts-debug/* / && chmod +x /*.sh
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

# Final clean up
# RUN rm -Rf /testdasi
