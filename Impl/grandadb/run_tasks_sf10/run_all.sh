PORT=5678
mkdir -p ../log
./run_ecommerce.sh $PORT > ../log/$(date +\%Y\%m\%d\%H\%M\%S)_run_ecommerce_tasks.log 2>&1
./run_healthcare.sh $PORT > ../log/$(date +\%Y\%m\%d\%H\%M\%S)_run_healthcare_tasks.log 2>&1
./run_disaster.sh $PORT > ../log/$(date +\%Y\%m\%d\%H\%M\%S)_run_disaster_tasks.log 2>&1