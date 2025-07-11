DATASET_PATH=$1
USERNAME=$2
PASSWORD=$3
PORT=$4
# Create DB
arangosh --server.username $USERNAME --server.password $PASSWORD --javascript.execute-string "db._createDatabase('Ecommerce');" --server.endpoint tcp://127.0.0.1:$PORT

## LOAD TABLE
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/table/Brand.csv" --type csv --collection "Brand" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/table/Customer.csv" --type csv --separator "|" --collection "Customer" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/table/Product.csv" --type csv --collection "Product" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT

## LOAD JSON
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/json/order.json" --type json --collection "Order" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/json/review.json" --type json --collection "Review" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT

## LOAD GRAPH
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/property_graph/person_node.csv" --separator "|" --type csv  --translate "person_id=_key" --collection "Person" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/property_graph/hashtag_node.csv" --type csv  --translate "tag_id=_key" --collection "Shopping_Hashtag" --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/property_graph/person_follows_person.csv" --type csv --separator "|" --translate "_from=_from" --translate "_to=_to" --collection "Follows" --from-collection-prefix Person --to-collection-prefix Person --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --create-collection-type edge --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangoimport --overwrite true --file "$DATASET_PATH/ecommerce/property_graph/person_interestedIn_tag.csv" --type csv --translate "person_id=_from" --translate "tag_id=_to" --translate "created_time=created_date" --collection "Interested_in" --from-collection-prefix Person --to-collection-prefix Shopping_Hashtag --server.username $USERNAME  --server.password "$PASSWORD" --create-collection true --create-collection-type edge --threads 4 --server.database Ecommerce --server.endpoint tcp://127.0.0.1:$PORT
arangosh --server.database "Ecommerce" --server.username $USERNAME --server.password $PASSWORD --javascript.execute  $(pwd)/create_index.js --server.endpoint tcp://127.0.0.1:$PORT