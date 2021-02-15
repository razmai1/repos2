FROM heroku/heroku:18

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim nano tar wget sudo && \
  rm -rf /var/lib/apt/lists/*
  
ADD heroku-exec.sh .
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

### u29515 user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 8737 -G sudo -md /home/u8737 -s /bin/bash -p u8737 u8737 \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers


CMD bash heroku-exec.sh
