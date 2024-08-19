FROM python:3.8
LABEL authors="overlayai"

USER root

RUN apt update && apt install git libusb-1.0-0 ffmpeg libsm6 libxext6 -y
RUN export PATH="/usr/bin/git:$PATH"

RUN git clone https://github.com/overlay-ai-pty-ltd/examples.git 

USER 1001

RUN pip install pycocotools

# install the patched model maker library
RUN pip install examples/tensorflow_examples/lite/model_maker/pip_package