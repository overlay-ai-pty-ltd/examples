# Python 3.9: pyjwt>=2.10 (via firebase-admin in Cluster-Worker) needs >=3.9,
# and scann==1.2.6 only ships wheels up to cp39. The tensorflow/tensorflow
# GPU images are 3.8 (<=2.13) or 3.11 (>=2.14), so start from CUDA directly.
# scann==1.2.6 pins tensorflow 2.8.x, which pip installs below.
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04
LABEL authors="overlayai"

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3.9 python3.9-dev python3.9-distutils curl ca-certificates \
      git libusb-1.0-0 ffmpeg libsm6 libxext6 sudo \
 && ln -sf /usr/bin/python3.9 /usr/local/bin/python3 \
 && ln -sf /usr/bin/python3.9 /usr/local/bin/python \
 && curl -sS https://bootstrap.pypa.io/pip/3.9/get-pip.py | python3.9 \
 && rm -rf /var/lib/apt/lists/*

RUN export PATH="/usr/bin/git:$PATH"


COPY ./tensorflow_examples ./tensorflow_examples
ENV PATH "/.local/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
RUN mkdir -p /.local && chown -R 1001:1001 /.local && mkdir -p /.cache && chown -R 1001:1001 /.cache

RUN pip install pycocotools

# install the patched model maker library
RUN pip install ./tensorflow_examples/lite/model_maker/pip_package

USER 1001
