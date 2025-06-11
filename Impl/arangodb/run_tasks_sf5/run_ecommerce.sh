USERNAME=$1
PASSWORD=$2
PORT=$3

echo "T0 ==============="
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task0_1.js --server.endpoint tcp://127.0.0.1:$PORT
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task0_2.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T0 finished ======"
echo
echo

echo "T1 ==============="
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task1.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T1 finished ======"
echo
echo

echo "T2 ===============" 
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task2_1.js --server.endpoint tcp://127.0.0.1:$PORT
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task2_2.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T2 finished ======"
echo
echo

echo "T3 ==============="
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task3.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T3 finished ======"

echo
echo


echo "T4 ==============="
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task4.js
echo "T4 finished ======"

echo
echo

echo "T5 ==============="
time arangosh --server.database Ecommerce --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task5.js
echo "T5 finished ======"