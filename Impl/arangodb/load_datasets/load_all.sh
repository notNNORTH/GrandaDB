DATASET_PATH=/tmp/m2bench
USERNAME=
PASSWORD=
PORT=8530
DATA_PATH=$(pwd)/../../../Datasets_sf10/
ln -sfn $DATA_PATH/ecommerce /tmp/m2bench/ 2>&1 >& /dev/null
ln -sfn $DATA_PATH/healthcare /tmp/m2bench/ 2>&1 >& /dev/null 
ln -sfn $DATA_PATH/disaster /tmp/m2bench/ 2>&1 >& /dev/null

echo "==== E-commerce ===="
cd ecommerce
bash load_ecommerce.sh $DATASET_PATH $USERNAME $PASSWORD $PORT
cd ..

echo "==== Healthcare ===="
cd healthcare
bash load_healthcare.sh $DATASET_PATH $USERNAME $PASSWORD $PORT
cd ..

echo "==== Disaster & Safety ===="
cd disaster
bash load_disaster.sh $DATASET_PATH $USERNAME $PASSWORD $PORT
cd ..
