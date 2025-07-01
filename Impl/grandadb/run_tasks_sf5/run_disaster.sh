PORT=$1
echo "T10"
time gsql -d disaster -f Task10.sql -p $PORT
echo
echo "T11"
time gsql -d disaster -f Task11.sql -p $PORT
echo
echo "T12"
time gsql -d disaster -f Task12.sql -p $PORT
echo
echo "T13"
time gsql -d disaster -f Task13.sql -p $PORT
echo
T1=5
T2=10
echo "T14"
time gsql -d disaster -v Z1=$T1 -v Z2=$T2 -f Task14.sql -p $PORT
echo
echo "T15"
time gsql  -d disaster -v Z1=$T1 -v Z2=$T2 -v CLON=-118.0614431 -v CLAT=34.068509 -f  Task15.sql -p $PORT
echo
echo "T16"
time gsql -d disaster -f Task16.sql -p $PORT
echo