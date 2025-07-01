PORT=$1
echo "T0"
time gsql -d ecommerce -f Task0.sql -p $PORT
echo
echo "T1"
time gsql -d ecommerce -f Task1.sql -p $PORT
echo
echo "T2"
time gsql -d ecommerce -f Task2.sql -p $PORT
echo
echo "T3"
time gsql -d ecommerce -f Task3.sql -p $PORT
echo
echo "T4"
time gsql -d ecommerce -f Task4.sql -p $PORT
echo
echo "T5"
time gsql -d ecommerce -f Task5.sql -p $PORT
echo