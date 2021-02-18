FROM heroku/heroku:18

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y cmake libuv1-dev libssl-dev libhwloc-dev && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim nano tar wget sudo && \
  rm -rf /var/lib/apt/lists/*
  
ADD heroku-exec.sh .
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN groupadd --gid 15377 razi \
    && useradd --home-dir /home/razi --create-home --uid 15377 \
        --gid 15377 --shell /bin/sh --skel /dev/null razi \



CMD bash heroku-exec.sh
