FROM ubuntu:16.04

# defaults to latest LTS
ARG NODE_VERSION=8.11.1

ENV NODE_VERSION ${NODE_VERSION}

RUN apt-get update -qq

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y rsync sudo git python-software-properties software-properties-common build-essential curl vim jq bc rsync

# install gcloud from sources
RUN curl https://sdk.cloud.google.com | bash && \
    ln -s /root/google-cloud-sdk/bin/* /usr/local/bin/ && \
    echo 'source /root/google-cloud-sdk/path.bash.inc' > /etc/profile.d/gcloud && \
    echo 'source /root/google-cloud-sdk/completion.bash.inc' >> /etc/profile.d/gcloud
# install gcloud extra components
ARG GCLOUD_COMPONENTS=beta
RUN /bin/bash --login -c 'gcloud components install $GCLOUD_COMPONENTS && gcloud components update'

# Installing nodejs from binaries
RUN cd /tmp && \
  curl -k "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" -o node-linux-x64.tar.gz && \
  tar -zxvf "node-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
  rm node-linux-x64.tar.gz && \
  ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
  cd -

# Install npm stack
RUN /bin/bash -c 'cd /opt; \
    npm install gulp && \
    npm install @angular/cli && \
    ln -s /opt/node_modules/.bin/* /usr/local/bin/'

#ADD assets /assets

ENTRYPOINT ["/bin/bash", "--login"]
