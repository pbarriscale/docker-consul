FROM 		progrium/busybox
MAINTAINER 	Jeff Lindsay <progrium@gmail.com>

ADD https://github.com/sequenceiq/consul/releases/download/0.5.0rc1/0.5.0rc1_linux_amd64.zip /tmp/ 
RUN unzip /tmp/0.5.0rc1_linux_amd64.zip -d /bin/

ADD https://github.com/sequenceiq/consul/releases/download/0.5.0rc1/0.5.0rc1_web_ui.zip /tmp/webui.zip
RUN cd /tmp && unzip /tmp/webui.zip && mv dist /ui && rm /tmp/webui.zip

ADD https://get.docker.io/builds/Linux/x86_64/docker-1.4.1 /bin/docker
RUN chmod +x /bin/docker

RUN opkg-install curl bash

ADD ./config /config/
ONBUILD ADD ./config /config/

ADD ./start /bin/start
ADD ./check-http /bin/check-http
ADD ./check-cmd /bin/check-cmd

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/data"]

ENV SHELL /bin/bash

#COPY ./local-cluster /bin/local-cluster

ENTRYPOINT ["/bin/start"]
CMD []
