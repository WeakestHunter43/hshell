FROM ubuntu:latest

# Install all the required packages
WORKDIR /home/absentsun/
RUN chmod 777 /home/absentsun/
RUN apt-get -qq update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:wahibre/mtn
RUN apt-get -qq update && \
    apt-get install -y mtn \

# install required packages
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get -qq update && apt-get -qq install -y \
    # this package is required to fetch "contents" via "TLS"
    apt-transport-https cmake protobuf-compiler \
    # install coreutils
    coreutils aria2 jq pv gcc g++ htop vim nano \
    # install encoding tools
    mediainfo tmux fuse ffmpeg mkvtoolnix \
    curl git gnupg2 unzip wget pv jq build-essential make \
    # miscellaneous
    neofetch python3 python3-pip git bash bash-completion \
    locales python-lxml gettext-base xz-utils \
    # install extraction tools
    p7zip-full p7zip-rar rar unrar zip unzip \
    # miscellaneous helpers
    mediainfo && \
    # clean up the container "layer", after we are done
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV LANG C.UTF-8

# we don't have an interactive xTerm
ENV DEBIAN_FRONTEND noninteractive

# sets the TimeZone, to be used inside the container
ENV TZ Asia/Kolkata

# rclone ,gclone and fclone
RUN curl https://rclone.org/install.sh | bash

# Copies config(if it exists)
COPY . .

#install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN curl -sL https://deb.nodesource.com/setup_14.x | sh
RUN apt-get install -y nodejs
RUN npm install -g node-gyp
RUN npm install -g skynet-cli
RUN npm install
CMD node server
