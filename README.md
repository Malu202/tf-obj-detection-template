# tf-obj-detection-template

This is a simple template, following the tutorial from [here](https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html) with minor changes (mostly directory names). This assumes you already have your data annotated (in a csv file) and split into a training and testing subset.

## Prerequisites
For this to work you need the following software installed:

* A Linux OS
* [Docker](https://docs.docker.com/install/)
* [Nvidia-Docker](https://github.com/NVIDIA/nvidia-docker)

## Training your model
### Build the Docker Image
Open a terminal in the **tf-obj-detection-template/docker directory** and build the image with:

```Shell
docker build . -t tf-obj-detection-template 
```
If everything worked you should now see the image tagged tf-obj-detection-template when you run

```Shell
docker images 
```

### Convert the annotations
For this to work you need your csv files formatted like:

```Csv
filename,xmin,ymin,xmax,ymax,class
image1.jpg,654,510,674,527,cat
image2.jpg,446,629,481,671,dog
...
```
for both your testing and training dataset.

Put both files in the **workspace/annotations** directory and name them **test_labels.csv** and **train_labels.csv** respectively.
Also put your images in **workspace/images**.

Then modify the first line of annotations.sh to match your annotations, e.g.:
```Shell
 labels = --label0=cat --label1=dog
```
**Note:** if you need more labels you can add --label2=... etc. but you must also modify /workspace/scripts/generate_tfrecord.py by adding label flags (just copy both lines with label1, or remove them if you only need one class)

```Shell
 docker run --gpus all -v $PWD:/tmp -w /tmp --rm -it tf-obj-detection-template /bin/bash annotations.sh 
```
Make sure there are no errors before continuing. Now you should have two .record files in your workspace/annotation folder each a few MB in size.

#### Create a label map
Create a file in the annotations directory named **label_map.pbtxt** and set its content to:

```js
item {
    id: 1
    name: 'cat'
}

item {
    id: 2
    name: 'dog'
}
```
Replacing of course "cat" and "dog" withy your own labels. Again you can add more labels if you followed the steps while creating the .tfrecords files.
### Setup training
Download a sample config for your chosen model from [here](https://github.com/tensorflow/models/tree/master/research/object_detection/samples/configs) and a pre-trained model from [here](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md#coco-trained-models-coco-models).
Put the config file in to **workspace/training** folder and extract the content of the pre trained model download into **workspace/pre-trained-model**.
Modify the following lines of the config file:
```js
num_classes: 2
fine_tune_checkpoint: "pre-trained-model/model.ckpt.index"
batch_size: 12

train_input_reader: {
    tf_record_input_reader {
        input_path: "annotations/train.record"
    }
    label_map_path: "annotations/label_map.pbtxt"
num_examples: 8000

eval_input_reader: {
    tf_record_input_reader {
        input_path: "annotations/test.record"
    }
    label_map_path: "annotations/label_map.pbtxt"
...
}
```
Where *num_classes*, *batch_size*, *num_examples* (= amount of images for evaluation) are specific to your dataset and training.

Next modify the filename in *train.sh* to the name of your config file (without the path).
## Start the training
From workspace folder run:
```Shell
docker run --gpus all -p 6006:6006 -v $PWD:/tmp -w /tmp --rm -it tf-obj-detection-template /bin/bash train.sh
```
It might take a while to start outputing. You can monitor the process from your browser at http://localhost:6006/
## Usefull commands
### Docker
This will launch an interactive terminal inside your docker container where you can run commands or install packages.

**Note:** All changes will be reset after you exit the terminal with *exit*.
```Bash
docker run --gpus all -p 6006:6006 -v $PWD:/tmp -w /tmp --rm -it tf-obj-detection-template /bin/bash
```
To stop a container you can press ctrl+C. If that does not work, you first have to find its id by typing:
```Bash
docker ps -a
```
and then use that id to stop it:
```Bash
docker stop <id from above>
```
### Graphics Card
This shows your gpu utilization. You can also run this inside your container (like mentioned before) so you can check if your gpu is detected by the container
```Bash
nvidia-smi
```
## Export a model
In *export.sh* change the parameters for your data, eg:

```bash
input_shape_width=640
input_shape_width=640
config_filename=ssd_resnet50_fpn.config
checkpoint_number=7441
```
and run

```bash
docker run --gpus all -p 6006:6006 -v $PWD:/tmp -w /tmp --rm -it tf-obj-detection-template /bin/bash export.sh
```

## FAQ
**Why not tensorflow 2.0?**

For object detection there are a lot more models listed in [tensorflow/models/research](https://github.com/tensorflow/models/tree/master/research/object_detection) which requires tensorflow 1.15.0 than in [tensorflow/models/official](https://github.com/tensorflow/models/tree/master/official) which is based on tensorflow 2.0.0. Of course this will probably change in the future.

**I get a lot of deprecation warnings, why is that?**

This template uses an older version of tensorflow as explained above, which results in a lot of deprecation warnings. It should however work nevertheless.
