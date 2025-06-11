PORT=$1
echo "T6"
time gsql -d healthcare -f Task6.sql -p $PORT
echo
echo "T7"
time gsql -d healthcare -f Task7.sql -p $PORT
echo
echo "T8"
time gsql -d healthcare -f Task8.sql -p $PORT
echo
echo "T9"
time gsql -d healthcare -f Task9.sql -p $PORT
echo