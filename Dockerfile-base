FROM python:3

# if you want to pip install viper-framework
#RUN apt update \
#    && apt install -y git gcc python3-dev python3-pip \
#    && apt-get -y install libfuzzy-dev \
#    && pip3 install viper-framework

# from docs
RUN apt update \
    && apt install -y git gcc python3-dev python3-pip

# fix
RUN apt install -y libfuzzy-dev

# install latest from git
RUN git clone https://github.com/viper-framework/viper \
    && cd viper \
    && pip3 install .
