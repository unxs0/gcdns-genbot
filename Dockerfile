FROM ubuntu
MAINTAINER Unxs Support genbots@unxs.io

# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    wget \
    supervisor \
    curl \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

# Install docker-gen
ENV DOCKER_GEN_VERSION 0.7.3
RUN wget --quiet --no-check-certificate https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

# Install gcloud
RUN wget --quiet --no-check-certificate https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-140.0.0-linux-x86_64.tar.gz > /dev/null 2>&1
RUN tar xzf google-cloud-sdk-140.0.0-linux-x86_64.tar.gz > /dev/null 2>&1 && rm google-cloud-sdk-140.0.0-linux-x86_64.tar.gz

RUN mkdir -p /var/local/dockbot
COPY ./gcloudauth.sh /usr/bin/gcloudauth.sh

COPY . /app/
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD gcdns.sh /usr/bin/gcdns.sh
WORKDIR /app/

ENV DOCKER_HOST unix:///var/run/docker.sock

CMD ["/usr/bin/supervisord","-n"]

# docker build -t unxsio/gcdns-genbot .
#
# install gc-credentials.json in /var/local/dockprox on host
#
# docker run --restart unless-stopped --name gcdns-genbot --env cGCDNSProject=adhoc-dev --env cGCDNSZone=sistemasadhoc-com -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/local/dockprox:/var/local/dockprox -d unxsio/gcdns-genbot
