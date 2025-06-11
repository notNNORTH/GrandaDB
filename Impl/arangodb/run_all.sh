#arangodb
#sf1
/home/pyw/local/arangodb/sbin/arangod \
  --config /home/pyw/local/arangodb/etc/arangodb3/arangod.conf \
  --daemon \
  --pid-file /home/pyw/data/arangodb_data/logs/arangod.pid
echo "Start waiting..."
sleep 30
echo "Done waiting."
cd /home/pyw/m2benchtest/Impl/arangodb/run_tasks
bash /home/pyw/m2benchtest/Impl/arangodb/run_tasks/run_all.sh

kill -TERM $(cat /home/pyw/data/arangodb_data/logs/arangod.pid)
#sf2
/home/pyw/local/arangodb/sbin/arangod \
  --config /home/pyw/local/arangodb/etc/arangodb3/arangod_sf2.conf \
  --daemon \
  --pid-file /home/pyw/data/arangodb_data_sf2/logs/arangod.pid
echo "Start waiting..."
sleep 30
echo "Done waiting."
cd /home/pyw/m2benchtest/Impl/arangodb/run_tasks_sf2
bash /home/pyw/m2benchtest/Impl/arangodb/run_tasks_sf2/run_all.sh

kill -TERM $(cat /home/pyw/data/arangodb_data_sf2/logs/arangod.pid)
#sf5
/home/pyw/local/arangodb/sbin/arangod \
  --config /home/pyw/local/arangodb/etc/arangodb3/arangod_sf5.conf \
  --daemon \
  --pid-file /home/pyw/data/arangodb_data_sf5/logs/arangod.pid
echo "Start waiting..."
sleep 60
echo "Done waiting."
cd /home/pyw/m2benchtest/Impl/arangodb/run_tasks_sf5
bash /home/pyw/m2benchtest/Impl/arangodb/run_tasks_sf5/run_all.sh

kill -TERM $(cat /home/pyw/data/arangodb_data_sf5/logs/arangod.pid)
#sf10
/home/pyw/local/arangodb/sbin/arangod \
  --config /home/pyw/local/arangodb/etc/arangodb3/arangod_sf10.conf \
  --daemon \
  --pid-file /home/pyw/data/arangodb_data_sf10/logs/arangod.pid
echo "Start waiting..."
sleep 60
echo "Done waiting."
cd /home/pyw/m2benchtest/Impl/arangodb/run_tasks_sf10
bash /home/pyw/m2benchtest/Impl/arangodb/run_tasks_sf10/run_all.sh

kill -TERM $(cat /home/pyw/data/arangodb_data_sf10/logs/arangod.pid)