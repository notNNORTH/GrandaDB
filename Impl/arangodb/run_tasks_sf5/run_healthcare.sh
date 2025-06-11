USERNAME=$1
PASSWORD=$2
PORT=$3

echo "T6 ==============="
time arangosh --server.database Healthcare --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task6.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T6 finished ======"

echo
echo

echo "T7 ===============" 
time arangosh --server.database Healthcare --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task7.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T7 finished ======" 

echo
echo

echo "T8 ==============="
time arangosh --server.database Healthcare --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task8_1.js --server.endpoint tcp://127.0.0.1:$PORT
time arangosh --server.database Healthcare --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task8_2.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T8 finished ======"

echo
echo


echo "T9 ==============="
time arangosh --server.database Healthcare --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 7200  --javascript.execute  Task9_1.js --server.endpoint tcp://127.0.0.1:$PORT
time arangosh --server.database Healthcare --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task9_2.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T9 finished ======"
