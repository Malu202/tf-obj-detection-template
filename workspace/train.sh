tensorboard --logdir output/ &
python model_main.py --alsologtostderr --model_dir=output/ --pipeline_config_path=training/INSERT_CONFIG_FILENAME.config

