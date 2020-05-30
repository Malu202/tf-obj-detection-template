#Modify this line:
labels = --label0=<LABEL> --label1=<LABEL>

python generate_tfrecord.py $labels --csv_input=annotations/train_labels.csv  --output_path=annotations/train.record
python generate_tfrecord.py $labels --csv_input=annotations/test_labels.csv  --output_path=annotations/test.record
