FROM tensorflow/tensorflow:1.15.0-gpu-py3
ENV DEBIAN_FRONTEND=noninteractive 


RUN apt-get update && apt-get install protobuf-compiler python-pil python-lxml python-tk git -y

RUN pip3 install --upgrade pip

RUN pip3 install pillow
RUN pip3 install lxml
RUN pip3 install Cython
RUN pip3 install jupyter
RUN pip3 install matplotlib
RUN pip3 install pandas
RUN pip3 install opencv-python

RUN pip3 install contextlib2
RUN pip3 install pycocotools

RUN git clone https://github.com/tensorflow/models.git
ENV PYTHONPATH "${PYTHONPATH}:/models; /models/research; /models/research/slim"

RUN pip3 install pycocotools


RUN cd /models/research && protoc ./object_detection/protos/*.proto --python_out=.

RUN cd /models/research/ && python3 setup.py build && python3 setup.py install

RUN cd /models/research/slim && python3 setup.py build && python3 setup.py install


RUN pip3 install h5py numpy keras
RUN pip3 install --no-deps tensorflowjs
