DATASET_PATH=$1
USERNAME=$2
PASSWORD=$3
PORT=$4
# Create DB
arangosh --server.username $USERNAME --server.password $PASSWORD --javascript.execute-string "db._createDatabase('Disaster');" --server.endpoint tcp://127.0.0.1:$PORT

# LOAD TABLE
arangoimport --overwrite true  --file "$DATASET_PATH/disaster/table/Earthquake.csv" --type csv --collection "Earthquake" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/disaster/table/Gps.csv" --type csv --collection "Gps" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/disaster/table/Shelter.csv" --type csv --separator "|" --collection "Shelter" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT

#LOAD JSON
arangoimport --overwrite true --file "$DATASET_PATH/disaster/json/Site.json" --type json --collection "Site" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/disaster/json/Site_centroid.json" --type json --collection "Site_centroid" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT

#LOAD GRAPH
arangoimport --overwrite true --file "$DATASET_PATH/disaster/property_graph/Roadnode.csv" --type csv --translate "roadnode_id=_key" --collection "Roadnode" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/disaster/property_graph/Road.csv" --type csv --translate "from=_from" --translate "to=_to" --collection "Road" --from-collection-prefix Roadnode --to-collection-prefix Roadnode --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --create-collection-type edge --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT

#LOAD ARRAY
arangoimport --overwrite true --file "$DATASET_PATH/disaster/array/Finedust_idx.csv" --type csv --collection "Finedust_idx" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Disaster --server.endpoint tcp://127.0.0.1:$PORT

arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --javascript.execute  $(pwd)/create_index.js --server.endpoint tcp://127.0.0.1:$PORT
arangosh --server.database Disaster --server.username $USERNAME --server.password $PASSWORD --javascript.execute  $(pwd)/create_graph.js --server.endpoint tcp://127.0.0.1:$PORT