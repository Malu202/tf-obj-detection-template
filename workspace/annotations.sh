#Modify this line:
labels = --label0=<LABEL> --label1=<LABEL>

python scripts/generate_tfrecord.py $labels --csv_input=${PWD}/annotations/train_labels.csv --img_path=${PWD}/images/  --output_path=${PWD}/annotations/train.record
python scripts/generate_tfrecord.py $labels --csv_input=${PWD}/annotations/test_labels.csv --img_path=${PWD}/images/ --output_path=${PWD}/annotations/test.record
