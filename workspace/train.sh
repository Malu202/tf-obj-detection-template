#Modify this line:
config_filename=INSERT_CONFIG_FILENAME.config

tensorboard --logdir output/ &
python model_main.py --alsologtostderr --model_dir=output/ --pipeline_config_path=training/$config_filename

