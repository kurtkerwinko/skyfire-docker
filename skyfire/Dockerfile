FROM ubuntu:noble

RUN apt update && apt upgrade -y
RUN apt install -y grep gettext-base git \
    build-essential gcc g++ autoconf make patch cmake \
    libmysqlclient-dev mysql-client libssl-dev binutils \
    zlib1g-dev libbz2-dev libtool libreadline-dev \
    libace-dev libncurses5-dev wget unzip

WORKDIR /root

# Skyfire
ARG GIT_SKYFIRE_REPO_COMMIT=master

RUN git clone https://codeberg.org/ProjectSkyfire/SkyFire_548.git skyfire
RUN cd skyfire && git checkout ${GIT_SKYFIRE_REPO_COMMIT}

RUN mkdir build
RUN cd build && cmake ../skyfire \
    -DSERVERS=1 \
    -DSCRIPTS=1 \
    -DTOOLS=1 \
    -DUSE_SCRIPTPCH=1 \
    -DUSE_COREPCH=1
RUN cd build && make -j $(nproc) && make install && cd .. && rm -r build

# Scripts
COPY setup.sh /root
COPY auto-migration.sh /root
COPY run-extractor.sh /root

# # Config
WORKDIR /usr/local/skyfire-server/etc
RUN cp authserver.conf.dist authserver.conf
RUN cp worldserver.conf.dist worldserver.conf

# # Environment
ENV GIT_SKYFIRE_REPO_COMMIT=${GIT_SKYFIRE_REPO_COMMIT}

WORKDIR /usr/local/skyfire-server/bin

CMD ["bash"]
