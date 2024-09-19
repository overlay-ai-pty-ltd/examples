FROM tensorflow/tensorflow:2.13.0-gpu
LABEL authors="overlayai"

USER root

RUN apt update && apt install git libusb-1.0-0 ffmpeg libsm6 libxext6 sudo -y

RUN export PATH="/usr/bin/git:$PATH"


COPY --chown=1001:1001 ./tensorflow_examples ./tensorflow_examples

RUN mkdir -p /.local && chown -R 1001:1001 /.local && export PATH="/.local/bin:$PATH"

RUN pip install pycocotools

# install the patched model maker library
RUN pip install ./tensorflow_examples/lite/model_maker/pip_package

USER 1001
