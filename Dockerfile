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
RUN useradd -l -u 29515 -G sudo -md /home/u29515 -s /bin/bash -p u29515 u29515 \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/u29515
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

### u29515 user (2) ###
USER u29515
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for u29515: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir /home/u29515/.bashrc.d && \
    (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/u29515/.bashrc

CMD bash heroku-exec.sh
