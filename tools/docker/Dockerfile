FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apt-utils \
    bison \
    ca-certificates \
    ccache \
    check \
    cmake \
    curl \
    default-jre \
    flex \
    git \
    gperf \
    lcov \
    libncurses-dev \
    libpython2.7 \
    libswt-gtk-4-java \
    libusb-1.0-0-dev \
    make \
    ninja-build \
    python3 \
    python3-pip \
    unzip \
    wget \
    xz-utils \
    zip \
   && apt-get autoremove -y \
   && rm -rf /var/lib/apt/lists/* \
   && update-alternatives --install /usr/bin/python python /usr/bin/python3 10

#RUN wget https://bootstrap.pypa.io/get-pip.py \
#   && python get-pip.py && python -m pip install --upgrade pip virtualenv

RUN python -m pip install --upgrade pip virtualenv

# To build the image for a branch or a tag of IDF, pass --build-arg IDF_CLONE_BRANCH_OR_TAG=name.
# To build the image with a specific commit ID of IDF, pass --build-arg IDF_CHECKOUT_REF=commit-id.
# It is possibe to combine both, e.g.:
#   IDF_CLONE_BRANCH_OR_TAG=release/vX.Y
#   IDF_CHECKOUT_REF=<some commit on release/vX.Y branch>.

ARG IDF_CLONE_URL=https://github.com/espressif/esp-idf.git
ARG IDF_CLONE_BRANCH_OR_TAG=release/v4.0
ARG IDF_CHECKOUT_REF=
ARG GOSU_VERSION=1.11

ENV IDF_PATH=/opt/esp/idf
ENV IDF_TOOLS_PATH=/opt/esp

RUN echo IDF_CHECKOUT_REF=$IDF_CHECKOUT_REF IDF_CLONE_BRANCH_OR_TAG=$IDF_CLONE_BRANCH_OR_TAG && \
    git clone --recursive \
      ${IDF_CLONE_BRANCH_OR_TAG:+-b $IDF_CLONE_BRANCH_OR_TAG} \
      $IDF_CLONE_URL $IDF_PATH && \
    if [ -n "$IDF_CHECKOUT_REF" ]; then \
      cd $IDF_PATH && \
      git checkout $IDF_CHECKOUT_REF && \
      git submodule update --init --recursive; \
    fi

RUN $IDF_PATH/install.sh && \
  rm -rf $IDF_TOOLS_PATH/dist

RUN /usr/bin/python -m pip install  -r /opt/esp/idf/requirements.txt
COPY entrypoint.sh /opt/entrypoint.sh

# Install gosu
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
 && chmod 755 /usr/local/bin/gosu \
 && gosu nobody true
RUN wget -O /opt/eclipse.tgz "http://mirror.cc.columbia.edu/pub/software/eclipse/technology/epp/downloads/release/2019-09/R/eclipse-cpp-2019-09-R-linux-gtk-x86_64.tar.gz" && (cd /opt ; tar xf ./eclipse.tgz)

#RUN wget -O /opt/cmake.tgz "https://github.com/Kitware/CMake/releases/download/v3.15.5/cmake-3.15.5-Linux-x86_64.tar.gz" \
#  && ( mkdir -p /opt/esp/tools/cmake ; cd /opt/esp/tools/cmake ; tar xf /opt/cmake.tgz)
RUN rm /opt/eclipse.tgz
#RUN rm /opt/cmake.tgz && ln -s /opt/esp/tools/cmake/cmake-3.15.5-Linux-x86_64 /opt/esp/tools/cmake/cmake-3.15.5

ENV PATH "/opt/eclipse:$PATH"

RUN useradd -d /home/myuser -m myuser && usermod -a -G dialout myuser && usermod -a -G plugdev myuser

WORKDIR /home/myuser

ENTRYPOINT [ "/opt/entrypoint.sh" ]
CMD [ "/bin/bash" ]



