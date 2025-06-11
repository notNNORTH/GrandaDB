USERNAME=$1
PASSWORD=$2
PORT=$3

echo "T10 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task10.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T10 finished ====="


echo
echo


echo "T11 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task11_1.js --server.endpoint tcp://127.0.0.1:$PORT
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task11_2.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T11 finished ====="

echo
echo


echo "T12 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task12.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T12 finished =====" 


echo
echo


echo "T13 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task13.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T13 finished =====" 

echo
echo

echo "T14 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task14.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T14 finished =====" 

echo
echo

echo "T15 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task15.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T15 finished ====="

echo
echo

echo "T16 =============="
time arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --server.request-timeout 18000  --javascript.execute  Task16.js --server.endpoint tcp://127.0.0.1:$PORT
echo "T16 finished ====="
