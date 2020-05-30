#Change these parameters:
input_shape_width=300
input_shape_height=300
config_filename=model.config
checkpoint_number=0000

python scripts/export_inference_graph.py \
	--input_type image_tensor \
	--input_shape 1,$input_shape_width,$input_shape_height,3 \
	--pipeline_config_path training/$config_filename \
	--trained_checkpoint_prefix output/model.ckpt-$checkpoint_number \
 	--output_directory export/
