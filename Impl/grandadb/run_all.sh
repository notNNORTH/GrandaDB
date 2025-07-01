#sf1
gs_ctl start -D /home/pyw/data/helmdb_data -Z single_node -l logfile1

cd /home/pyw/m2benchtest/Impl/helmdb/run_tasks
bash /home/pyw/m2benchtest/Impl/helmdb/run_tasks/run_all.sh

gs_ctl stop -D /home/pyw/data/helmdb_data -m immediate

#sf2
gs_ctl start -D /home/pyw/data/helmdb_data_sf2 -Z single_node -l logfile2

cd /home/pyw/m2benchtest/Impl/helmdb/run_tasks_sf2
bash /home/pyw/m2benchtest/Impl/helmdb/run_tasks_sf2/run_all.sh

gs_ctl stop -D /home/pyw/data/helmdb_data_sf2 -m immediate

#sf5
gs_ctl start -D /home/pyw/data/helmdb_data_sf5 -Z single_node -l logfile5

cd /home/pyw/m2benchtest/Impl/helmdb/run_tasks_sf5
bash /home/pyw/m2benchtest/Impl/helmdb/run_tasks_sf5/run_all.sh

gs_ctl stop -D /home/pyw/data/helmdb_data_sf5 -m immediate

#sf10
gs_ctl start -D /home/pyw/data/helmdb_data_sf10 -Z single_node -l logfile10

cd /home/pyw/m2benchtest/Impl/helmdb/run_tasks_sf10
bash /home/pyw/m2benchtest/Impl/helmdb/run_tasks_sf10/run_all.sh

gs_ctl stop -D /home/pyw/data/helmdb_data_sf10 -m immediate