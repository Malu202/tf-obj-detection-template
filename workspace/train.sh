#Modify this line:
config_filename=ssd_resnet50_fpn_640x640.config

tensorboard --logdir output/ &
python scripts/model_main.py --alsologtostderr --model_dir=output/ --pipeline_config_path=training/$config_filename

