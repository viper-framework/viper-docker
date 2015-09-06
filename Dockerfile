#
# This file is part of Viper - https://github.com/viper-framework/viper
# See the file 'LICENSE' for copying permission.
#

FROM ubuntu:14.04
MAINTAINER Viper-Framework (https://github.com/viper-framework)

USER root
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    python-dev \
    python-pip \
    curl \
    libtool \
    autoconf \
    python-socksipy \
    python-m2crypto \
    python-levenshtein \
    swig \
    libssl-dev \
    pff-tools \
    libimage-exiftool-perl && \
  rm -rf /var/lib/apt/lists/*

# Make Tmp Dir
RUN mkdir ~/tmp_build

# Install Yara
RUN cd ~/tmp_build && \
  git clone https://github.com/plusvic/yara.git && \
  cd yara && \
  bash build.sh && \
  make install && \
  cd yara-python && \
  python setup.py build && \
  python setup.py install && \
  cd ../.. && \
  rm -rf yara && \
  ldconfig

# Install SSDEEP
RUN cd ~/tmp_build &&\
  curl -SL http://sourceforge.net/projects/ssdeep/files/ssdeep-2.13/ssdeep-2.13.tar.gz/download | \
  tar -xzC .  && \
  cd ssdeep-2.13 && \
  ./configure && \
  make install && \
  pip install pydeep && \
  cd .. && \
  rm -rf ssdeep-2.13
  
# Install PyExif
RUN cd ~/tmp_build && \
  git clone git://github.com/smarnach/pyexiftool.git && \
  cd pyexiftool && \
  python setup.py install 
  
# Install AndroGuard
RUN cd ~/tmp_build && \
  curl -SL https://androguard.googlecode.com/files/androguard-1.9.tar.gz | \
  tar -xzC .  && \
  cd androguard-1.9 && \
  python setup.py install

# Create Viper User
RUN groupadd -r viper && \
  useradd -r -g viper -d /home/viper -s /sbin/nologin -c "Viper User" viper && \
  mkdir /home/viper && \
  chown -R viper:viper /home/viper

# Clean tmp_build
RUN rm -rf ~/tmp_build

USER viper
WORKDIR /home/viper
RUN git clone https://github.com/botherder/viper.git && \
  mkdir /home/viper/workdir

USER root
WORKDIR /home/viper/viper
RUN chmod a+xr viper.py && \
  pip install -r requirements.txt

USER viper
WORKDIR /home/viper/workdir
CMD ["../viper/viper.py"]
