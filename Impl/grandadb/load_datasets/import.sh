DATA_PATH=$(pwd)/../../../Datasets_sf10
PORT=5678
mkdir -p /tmp/m2bench/
ln -sfn $DATA_PATH/ecommerce /tmp/m2bench/ 2>&1 >& /dev/null
ln -sfn $DATA_PATH/healthcare /tmp/m2bench/ 2>&1 >& /dev/null 
ln -sfn $DATA_PATH/disaster /tmp/m2bench/ 2>&1 >& /dev/null

echo "==== E-commerce ===="
cd ecommerce
bash load_ecommerce.sh $PORT
cd ..

echo "==== Healthcare ===="
cd healthcare
bash load_healthcare.sh $PORT
cd ..

echo "==== Disaster & Safety ===="
cd disaster
bash load_disaster.sh $PORT
cd ..