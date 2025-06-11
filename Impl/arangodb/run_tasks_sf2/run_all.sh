USERNAME=
PASSWORD=
PORT=8530
mkdir -p ../log
./run_ecommerce.sh $USERNAME $PASSWORD $PORT > ../log/$(date +\%Y\%m\%d\%H\%M\%S)_run_ecommerce_tasks.log 2>&1 
./run_healthcare.sh $USERNAME $PASSWORD $PORT > ../log/$(date +\%Y\%m\%d\%H\%M\%S)_run_healthcare_tasks.log 2>&1 
./run_disaster.sh $USERNAME $PASSWORD $PORT > ../log/$(date +\%Y\%m\%d\%H\%M\%S)_run_disaster_tasks.log 2>&1 