python scripts/export_inference_graph.py \
	--input_type image_tensor \
	--input_shape 300,300,3 \
	--pipeline_config_path training/INSER_CONFIG_FILENAME.config \
	--trained_checkpoint_prefix output/model.ckpt-INSERT_CKPT_NUMBER \
 	--output_directory export/
