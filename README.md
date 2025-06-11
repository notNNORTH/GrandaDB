# <font style="color:#000000;">1. 引言</font>
## <font style="color:#000000;">1.1 目的</font>
<font style="color:#000000;">本性能测试旨在评估和比较HelmDB与ArangoDB在多模型（如关系、图、文档、数组）负载上的查询性能，重点关注</font>**<font style="color:#000000;">查询响应时间</font>**<font style="color:#000000;">等关键指标，以验证在相同条件下 HelmDB 的总运行时间是否比 ArangoDB 快</font>**<font style="color:#000000;">一个数量级</font>**<font style="color:#000000;">。</font>

## <font style="color:#000000;">1.2 范围</font>
<font style="color:#000000;">测试覆盖关系、图、文档等数据模型的存储与查询操作。</font>

<font style="color:#000000;">测试覆盖m2bench的Ecommerce、Healthcare以及Disaster三个场景总共17个查询Task。</font>

<font style="color:#000000;">测试不包括事务处理、安全性和备份恢复等功能。</font>

## <font style="color:#000000;">1.3 背景信息</font>
`**<font style="color:#000000;">M2Bench</font>**`<font style="color:#000000;">: 一个用于评估多模数据库性能的公开数据集。</font>

<font style="color:#000000;">随着数据库技术的发展，现代数据库系统逐渐能够支持多种数据模型的存储与管理，但现有的数据库基准测试往往只关注单一或少数数据模型。如流行的基准测试如TPC-H和TPC-DS只关注关系模型、XMark和NOBENCH只关注文档数据模型，LinkBench仅针对图模型进行测试，而最近新提出的UniBench虽然为多模基准测试，但是却不支持数组模型。这些基准测试在数据模型的覆盖上存在局限性，不能全面评估数据库对多种数据模型的存储能力。因此M2Bench作为一款针对多模数据库的基准测试被提出。该基准测试模拟3种实际应用场景、包含17项查询测试，并能够覆盖关系、文档、图和数组共4种数据模型，其设计框架如下图所示：</font>

![](https://cdn.nlark.com/yuque/0/2024/png/36173908/1734878946911-51ed3ee9-7938-469c-96f2-9976f585db73.png)

<font style="color:#000000;">M2Bench框架示意图</font>

<font style="color:#000000;">HelmDB: </font><font style="color:#000000;">新硬件多模</font><font style="color:#000000;">数据库系统。</font>

<font style="color:#000000;">ArangoDB: 一款多模型数据库系统，支持文档、键值、图数据模型。</font>

# 2.目标设定
## <font style="color:#000000;">2.1性能指标</font>
+ **<font style="color:#000000;">响应时间：</font>**<font style="color:#000000;">17个查询的总响应时间，取多次测试的平均数。</font>
+ **<font style="color:#000000;">代价估计：</font>**<font style="color:#000000;">查询计划能给出17个查询的代价</font>
+ **<font style="color:#000000;">资源利用率：</font>**<font style="color:#000000;">CPU、内存、磁盘I/O、网络带宽的使用情况。</font>

## <font style="color:#000000;">2.2 验收标准</font>
+ <font style="color:#000000;">HelmDB响应时间比ArangoDB快一个数量级（10倍以上）。</font>
+ <font style="color:#000000;">给出的查询计划代价能反映出查询实际执行所需要的时间。</font>
+ <font style="color:#000000;">系统资源利用率保持在合理范围内，避免过载。</font>

# <font style="color:#000000;">3. 测试环境</font>
## <font style="color:#000000;">3.1硬件配置：</font>
| **<font style="color:#000000;">CPU</font>** | Intel(R) Xeon(R) Gold 6330 CPU @ 2.00GHz |
| :---: | --- |
| **<font style="color:#000000;">内存</font>** | DDR4 <font style="color:rgba(0, 0, 0, 0.85);">Samsung M393A2K40DB3-CWE 16G*8</font> |
| **硬盘** | Samsung SSD 870 3.7T |


## <font style="color:#000000;">3.2软件配置：</font>
+ <font style="color:#000000;">操作系统：centos7.9</font>
+ <font style="color:#000000;">gcc版本：10.3</font>
+ <font style="color:#000000;">ArangoDB: 3.11.8 community</font>
+ <font style="color:#000000;">Helmdb：1.0</font>

## <font style="color:#000000;">3.3 测试工具</font>
+ <font style="color:#000000;">M2bench：生成数据集和查询负载</font>
+ <font style="color:#000000;">nmon/vmstat：监控系统资源和收集数据库性能指标。</font>

# <font style="color:#000000;">4. 测试流程</font>
## <font style="color:#000000;">4.1 环境安装</font>
### <font style="color:#000000;">Arangodb</font>
#### 安装
1. <font style="color:#000000;">下载</font>[arangodb3.11.8RPM包](https://download.arangodb.com/arangodb311/Community/Linux/index.html)

2. <font style="color:#000000;">上传到服务器并进行安装</font>

```shell
rpm -ivh arangodb3-3.11.8-1.0.x86_64.rpm
```

安装过程中会显示初始密码，示例如下：

```shell
current paasword: 6bbe691578e088b5dc33fb2623837e3f
```

3. <font style="color:#000000;">修改数据库的root用户密码</font>

```shell
sudo arango-secure-installation
```

4. <font style="color:#000000;">修改数据库数据目录</font>

```shell
sudo vim /etc/arangodb3/arangod.conf
```

<font style="color:#000000;">修改文件如下：</font>

```shell
[database]
directory = $ARANGODB_DATA_PATH #修改为指定的安装目录
```

<font style="color:#000000;">查看日志：</font>

```shell
sudo less /var/log/arangodb3/arangod.log
```

5. <font style="color:#000000;">修改数据目录权限</font>

```shell

chmod 777 $ARANGODB_DATA_PATH
chmod -R 777 ~/arangodb
```

#### <font style="color:#000000;">启动数据库服务</font>
```shell
sudo systemctl start arangodb3.service
# If install from source code, then use below script to start
/home/pyw/local/arangodb/sbin/arangod \
  --config /home/pyw/local/arangodb/etc/arangodb3/arangod.conf \
  --daemon \
  --pid-file /home/pyw/data/arangodb_data/logs/arangod.pid
```

<font style="color:#000000;">测试是否启动成功</font>

```shell
arangosh
```

![](https://cdn.nlark.com/yuque/0/2024/png/36173908/1734878946779-a3b08d96-161c-4c15-b29d-c8a3df3381a6.png)

### <font style="color:#000000;">gcc安装</font>
<font style="color:#000000;">在 CentOS 7.9 上编译安装 GCC 10.3 可以按照以下步骤进行：</font>

1. <font style="color:#000000;">下载 GCC 10.3 源代码：使用 wget 命令下载 GCC 10.3 源代码：</font>

```shell
wget https://ftp.gnu.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.gz
```

2. <font style="color:#000000;">解压源代码：解压下载的源代码包：</font>

```shell
tar -xzf gcc-10.3.0.tar.gz
```

3. <font style="color:#4d4d4d;">运行 download_prerequisites 脚本安装gcc所需的依赖</font>

```shell
cd gcc-10.3.0
./contrib/download_prerequisites
```

4. <font style="color:#000000;">创建编译目录：进入解压后的 GCC 目录并创建一个用于编译的目录：</font>

```shell
mkdir build
cd build
```

5. <font style="color:#000000;">配置编译选项：运行 configure 脚本来配置编译选项：</font>

```shell
../configure --prefix=/home/gauss/local/gcc-10.3 --disable-multilib --enable-languages=c,c++,fortran
```

<font style="color:#000000;">这里的 --prefix=/home/gauss/local/gcc-10.3 指定了安装目录，你可以根据需要选择其他目录。</font>

6. <font style="color:#000000;">编译和安装：运行 make 命令进行编译，然后运行 make install 安装：</font>

```shell
make -j$(nproc)
make install -sj
```

7. <font style="color:#000000;">修改环境变量</font><font style="color:#000000;">文件</font>

```shell
vim ～/.bashrc
```

```shell
# gcc
export GCC_PATH=/home/gauss/local/gcc-10.3
export CC=$GCC_PATH/bin/gcc
export CXX=$GCC_PATH/bin/g++
export LD_LIBRARY_PATH=$GCC_PATH/lib64:$LD_LIBRARY_PATH
export PATH=$GCC_PATH/bin:$PATH
```

<font style="color:#000000;">直接输入</font><font style="color:#000000;">gcc -v</font><font style="color:#000000;">，能识别到你的安装库即成功：</font>

![](https://cdn.nlark.com/yuque/0/2024/png/36173908/1734878946758-585e71ab-c262-45d6-9ba7-b515e2cdc892.png)

### **<font style="color:#000000;">HelmDB</font>**
#### <font style="color:#000000;">安装</font>
<font style="color:#000000;">代码地址：</font>

[https://edu.gitee.com/whudb/repos/whudb/HELMDB/sources](https://edu.gitee.com/whudb/repos/whudb/HELMDB/sources)  
（注：该仓库需要成为武汉大学组织成员才有权限访问，拉取HelmDB代码并切换到helmdb-develop分支）

<font style="color:#000000;">参考：</font>[opengauss6.0安装指南](https://gitee.com/opengauss/openGauss-server/tree/v6.0.0-RC1/)

1. <font style="color:#262626;">进入helmdb目录下，执行configure命令:</font>

```shell
./configure --gcc-version=10.3.0 CC=g++ CFLAGS=-O3 -g3 --prefix=$GAUSSHOME --3rd=$BINARYLIBS --enable-thread-safety --with-readline --without-zlib
```

2. <font style="color:#000000;">编译安装</font>

```shell
make -sj128
make install -sj128
```

3.修改环境变量

```shell
# opengauss
export BINARYLIBS=$HOME/local/openGauss-third_party_binarylibs_Centos7.6_x86_64
export GAUSSHOME=$HOME/local/opengauss
export LD_LIBRARY_PATH=$GAUSSHOME/lib:$LD_LIBRARY_PATH
export PATH=$GAUSSHOME/bin:$PATH
```

4.如果需要测试课题三的gpu版图算子或是关系算子

需要在configure时在后面加上对应的编译选项

```shell
# gpu graph operator
--enable-gpugraph
# gpu relation operator
--enable-gpuolap
```

并在系统中安装cuda并配置对应的环境变量：

```shell
export CUDA_HOME=/usr/local/cuda
export CUDA_LIB_PATH=/usr/local/cuda/lib64
export CUDA_INCLUDE_PATH=/usr/local/cuda/include
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export PATH=$CUDA_HOME/bin:$PATH
```

5.在安装完helmdb后，需要安装postgis，具体步骤以及使用指南详见上述链接

详见[Post Gis安装 | openGauss文档 | openGauss社区](https://docs.opengauss.org/zh/docs/6.0.0-RC1/docs/ExtensionReference/PostGIS%E5%AE%89%E8%A3%85.html)

6.在安装完helmdb后，需要安装ldbc

```shell
cd contrib/ldbc
make -sj
make install -sj
```

#### <font style="color:#000000;">启动</font>
1. 初始化数据目录

```shell
gs_initdb -D /home/pyw/data/helmdb_data --nodename="helmdb"
```

2. 进入数据目录修改配置文件postgresql.conf

```shell
# -----------------------------------------------------------------------------
#
# postgresql_single.conf.sample
#      Configuration file for centralized environment
#
# Portions Copyright (c) 1996-2012, PostgreSQL Global Development Group
#
#
# IDENTIFICATION
#      src/common/backend/utils/misc/postgresql_single.conf.sample
#
#
# This file consists of lines of the form:
#
#   name = value
#
# (The "=" is optional.)  Whitespace may be used.  Comments are introduced with
# "#" anywhere on a line.  The complete list of parameter names and allowed
# values can be found in the openGauss documentation.
#
# The commented-out settings shown in this file represent the default values.
# Re-commenting a setting is NOT sufficient to revert it to the default value;
# you need to reload the server.
#
# This file is read on server startup and when the server receives a SIGHUP
# signal.  If you edit the file on a running system, you have to SIGHUP the
# server for the changes to take effect, or use "pg_ctl reload".  Some
# parameters, which are marked below, require a server shutdown and restart to
# take effect.
#
# Any parameter can also be given as a command-line option to the server, e.g.,
# "postgres -c log_connections=on".  Some parameters can be changed at run time
# with the "SET" SQL command.
#
# Memory units:  kB = kilobytes        Time units:  ms  = milliseconds
#                MB = megabytes                     s   = seconds
#                GB = gigabytes                     min = minutes
#                                                   h   = hours
#                                                   d   = days
# -----------------------------------------------------------------------------


#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------

# The default values of these variables are driven from the -D command-line
# option or PGDATA environment variable, represented here as ConfigDir.

#data_directory = 'ConfigDir'		# use data in another directory
					# (change requires restart)
#hba_file = 'ConfigDir/pg_hba.conf'	# host-based authentication file
					# (change requires restart)
#ident_file = 'ConfigDir/pg_ident.conf'	# ident configuration file
					# (change requires restart)

# If external_pid_file is not explicitly set, no extra PID file is written.
#external_pid_file = ''			# write an extra PID file
					# (change requires restart)


#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -

listen_addresses = '*'		# what IP address(es) to listen on;
					# comma-separated list of addresses;
					# defaults to 'localhost'; use '*' for all
					# (change requires restart)
local_bind_address = '0.0.0.0'
port = 5678				# (change requires restart)
max_connections = 200			# (change requires restart)
# Note:  Increasing max_connections costs ~400 bytes of shared memory per
# connection slot, plus lock space (see max_locks_per_transaction).
#sysadmin_reserved_connections = 3	# (change requires restart)
#unix_socket_directory = ''		# (change requires restart)
#unix_socket_group = ''			# (change requires restart)
#unix_socket_permissions = 0700		# begin with 0 to use octal notation
					# (change requires restart)
#light_comm = off			# whether use light commnucation with nonblock mode or latch

# - Security and Authentication -

#authentication_timeout = 1min		# 1s-600s
session_timeout = 10min			# allowed duration of any unused session, 0s-86400s(1 day), 0 is disabled 
#idle_in_transaction_session_timeout = 0    # Sets the maximum allowed idle time between queries, when in a transaction, 0 is disabled
#ssl = off				# (change requires restart)
#ssl_ciphers = 'ALL'			# allowed SSL ciphers
					# (change requires restart)
#ssl_cert_notify_time = 90		# 7-180 days
#ssl_renegotiation_limit = 0		# amount of data between renegotiations, no longer supported
#ssl_cert_file = 'server.crt'		# (change requires restart)
#ssl_key_file = 'server.key'		# (change requires restart)
#ssl_ca_file = ''			# (change requires restart)
#ssl_crl_file = ''			# (change requires restart)

# Kerberos and GSSAPI
#krb_server_keyfile = ''
#krb_srvname = 'postgres'		# (Kerberos only)
#krb_caseins_users = off

#modify_initial_password = false	#Whether to change the initial password of the initial user
#password_policy = 1			#Whether password complexity checks
#password_reuse_time = 60		#Whether the new password can be reused in password_reuse_time days
#password_reuse_max = 0			#Whether the new password can be reused
#password_lock_time = 1			#The account will be unlocked automatically after a specified period of time
#failed_login_attempts = 10		#Enter the wrong password reached failed_login_attempts times, the current account will be locked
password_encryption_type = 1		#Password storage type, 0 is md5 for PG, 1 is sha256 + md5, 2 is sha256 only
#password_min_length = 8		#The minimal password length(6-999)
#password_max_length = 32		#The maximal password length(6-999)
#password_min_uppercase = 0		#The minimal upper character number in password(0-999)
#password_min_lowercase = 0		#The minimal lower character number in password(0-999)
#password_min_digital = 0		#The minimal digital character number in password(0-999)
#password_min_special = 0		#The minimal special character number in password(0-999)
#password_effect_time = 90d		#The password effect time(0-999)
#password_notify_time = 7d		#The password notify time(0-999)

# - TCP Keepalives -
# see "man 7 tcp" for details

#tcp_keepalives_idle = 0		# TCP_KEEPIDLE, in seconds;
					# 0 selects the system default
#tcp_keepalives_interval = 0		# TCP_KEEPINTVL, in seconds;
					# 0 selects the system default
#tcp_keepalives_count = 0		# TCP_KEEPCNT;
					# 0 selects the system default

#------------------------------------------------------------------------------
# RESOURCE USAGE (except WAL)
#------------------------------------------------------------------------------

# - Memory -
#memorypool_enable = false
#memorypool_size = 512MB

#enable_memory_limit = true
#max_process_memory = 12GB
#UDFWorkerMemHardLimit = 1GB

#enable_huge_pages = off      # (change requires restart)
#huge_page_size = 0     # make sure huge_page_size is valid for os. 0 as default.
                    # (change requires restart)
shared_buffers = 30GB			# min 128kB
					# (change requires restart)
bulk_write_ring_size = 2GB		# for bulkload, max shared_buffers
#standby_shared_buffers_fraction = 0.3 #control shared buffers use in standby, 0.1-1.0
#temp_buffers = 8MB			# min 800kB
max_prepared_transactions = 200		# zero disables the feature
					# (change requires restart)
# Note:  Increasing max_prepared_transactions costs ~600 bytes of shared memory
# per transaction slot, plus lock space (see max_locks_per_transaction).
# It is not advisable to set max_prepared_transactions nonzero unless you
# actively intend to use prepared transactions.
work_mem = 60GB				# min 64kB
maintenance_work_mem = 60GB		# min 1MB
#max_stack_depth = 2MB			# min 100kB

cstore_buffers = 512MB         #min 16MB

# - Disk -

#temp_file_limit = -1			# limits per-session temp file space
					# in kB, or -1 for no limit

#sql_use_spacelimit = -1                # limits for single SQL used space on single DN
					# in kB, or -1 for no limit

# - Kernel Resource Usage -

#max_files_per_process = 1000		# min 25
					# (change requires restart)
#shared_preload_libraries = ''         # (change requires restart)
# - Cost-Based Vacuum Delay -

#vacuum_cost_delay = 0ms		# 0-100 milliseconds
#vacuum_cost_page_hit = 1		# 0-10000 credits
#vacuum_cost_page_miss = 10		# 0-10000 credits
#vacuum_cost_page_dirty = 20		# 0-10000 credits
#vacuum_cost_limit = 200		# 1-10000 credits

# - Background Writer -

#bgwriter_delay = 10s			# 10-10000ms between rounds
#bgwriter_lru_maxpages = 100		# 0-1000 max buffers written/round
#bgwriter_lru_multiplier = 2.0		# 0-10.0 multipler on buffers scanned/round

# - Asynchronous Behavior -

#effective_io_concurrency = 1		# 1-1000; 0 disables prefetching


#------------------------------------------------------------------------------
# WRITE AHEAD LOG
#------------------------------------------------------------------------------

# - Settings -

wal_level = hot_standby			# minimal, archive, hot_standby or logical
					# (change requires restart)
#fsync = on				# turns forced synchronization on or off
#synchronous_commit = on		# synchronization level;
					# off, local, remote_receive, remote_write, or on
					# It's global control for all transactions
					# It could not be modified by gs_ctl reload, unless use setsyncmode.

#wal_sync_method = fsync		# the default is the first option
					# supported by the operating system:
					#   open_datasync
					#   fdatasync (default on Linux)
					#   fsync
					#   fsync_writethrough
					#   open_sync
#full_page_writes = on			# recover from partial page writes
#wal_buffers = 16MB			# min 32kB
					# (change requires restart)
#wal_writer_delay = 200ms		# 1-10000 milliseconds

#commit_delay = 0			# range 0-100000, in microseconds
#commit_siblings = 5			# range 1-1000

# - Checkpoints -

#checkpoint_segments = 64		# in logfile segments, min 1, 16MB each
#checkpoint_timeout = 15min		# range 30s-1h
#checkpoint_completion_target = 0.5	# checkpoint target duration, 0.0 - 1.0
#checkpoint_warning = 5min		# 0 disables
#checkpoint_wait_timeout = 60s  # maximum time wait checkpointer to start

enable_incremental_checkpoint = on	# enable incremental checkpoint
incremental_checkpoint_timeout = 60s	# range 1s-1h
#pagewriter_sleep = 100ms		# dirty page writer sleep time, 0ms - 1h

# - Archiving -

#archive_mode = off		# allows archiving to be done
				# (change requires restart)
#archive_command = ''		# command to use to archive a logfile segment
				# placeholders: %p = path of file to archive
				#               %f = file name only
				# e.g. 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'
#archive_timeout = 0		# force a logfile segment switch after this
				# number of seconds; 0 disables
#archive_dest = ''		# path to use to archive a logfile segment

#------------------------------------------------------------------------------
# REPLICATION
#------------------------------------------------------------------------------

# - heartbeat -
#datanode_heartbeat_interval = 1s         # The heartbeat interval of the standby nodes.
				 # The value is best configured less than half of 
				 # the wal_receiver_timeout and wal_sender_timeout.

# - Sending Server(s) -

# Set these on the master and on any standby that will send replication data.

max_wal_senders = 4		# max number of walsender processes
				# (change requires restart)
wal_keep_segments = 16		# in logfile segments, 16MB each normal, 1GB each in share storage mode; 0 disables
#wal_sender_timeout = 6s	# in milliseconds; 0 disables
enable_slot_log = off
max_replication_slots = 8

#max_changes_in_memory = 4096
#max_cached_tuplebufs = 8192

#replconninfo1 = ''		# replication connection information used to connect primary on standby, or standby on primary,
						# or connect primary or standby on secondary
						# The heartbeat thread will not start if not set localheartbeatport and remoteheartbeatport.
						# e.g. 'localhost=10.145.130.2 localport=12211 localheartbeatport=12214 remotehost=10.145.130.3 remoteport=12212 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12213 remotehost=10.145.133.3 remoteport=12214'
#replconninfo2 = ''		# replication connection information used to connect secondary on primary or standby,
						# or connect primary or standby on secondary
						# e.g. 'localhost=10.145.130.2 localport=12311 localheartbeatport=12214 remotehost=10.145.130.4 remoteport=12312 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12313 remotehost=10.145.133.4 remoteport=12314'
#replconninfo3 = ''             # replication connection information used to connect primary on standby, or standby on primary,
                                                # e.g. 'localhost=10.145.130.2 localport=12311 localheartbeatport=12214 remotehost=10.145.130.5 remoteport=12312 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12313 remotehost=10.145.133.5 remoteport=12314'
#replconninfo4 = ''             # replication connection information used to connect primary on standby, or standby on primary,
                                                # e.g. 'localhost=10.145.130.2 localport=12311 localheartbeatport=12214 remotehost=10.145.130.6 remoteport=12312 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12313 remotehost=10.145.133.6 remoteport=12314'
#replconninfo5 = ''             # replication connection information used to connect primary on standby, or standby on primary,
                                                # e.g. 'localhost=10.145.130.2 localport=12311 localheartbeatport=12214 remotehost=10.145.130.7 remoteport=12312 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12313 remotehost=10.145.133.7 remoteport=12314'
#replconninfo6 = ''             # replication connection information used to connect primary on standby, or standby on primary,
                                                # e.g. 'localhost=10.145.130.2 localport=12311 localheartbeatport=12214 remotehost=10.145.130.8 remoteport=12312 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12313 remotehost=10.145.133.8 remoteport=12314'
#replconninfo7 = ''             # replication connection information used to connect primary on standby, or standby on primary,
                                                # e.g. 'localhost=10.145.130.2 localport=12311 localheartbeatport=12214 remotehost=10.145.130.9 remoteport=12312 remoteheartbeatport=12215, localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo1 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo2 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo3 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo4 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo5 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo6 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'
#cross_cluster_replconninfo7 = ''             # replication connection information used to connect primary on primary cluster, or standby on standby cluster,
                                                # e.g. 'localhost=10.145.133.2 localport=12313 remotehost=10.145.133.9 remoteport=12314'

# - Master Server -

# These settings are ignored on a standby server.

synchronous_standby_names = '*'	# standby servers that provide sync rep
				# comma-separated list of application_name
				# from standby(s); '*' = all
#most_available_sync = off	# Whether master is allowed to continue
				# as standbalone after sync standby failure
				# It's global control for all transactions
#vacuum_defer_cleanup_age = 0	# number of xacts by which cleanup is delayed
#data_replicate_buffer_size = 16MB	# data replication buffer size
walsender_max_send_size = 8MB  # Size of walsender max send size
#enable_data_replicate = on

# - Standby Servers -

# These settings are ignored on a master server.

hot_standby = on			# "on" allows queries during recovery
					# (change requires restart)
#max_standby_archive_delay = 30s	# max delay before canceling queries
					# when reading WAL from archive;
					# -1 allows indefinite delay
#max_standby_streaming_delay = 30s	# max delay before canceling queries
					# when reading streaming WAL;
					# -1 allows indefinite delay
#wal_receiver_status_interval = 5s	# send replies at least this often
					# 0 disables
#hot_standby_feedback = off		# send info from standby to prevent
					# query conflicts
#wal_receiver_timeout = 6s		# time that receiver waits for
					# communication from master
					# in milliseconds; 0 disables
#wal_receiver_connect_timeout = 1s	# timeout that receiver connect master
							# in seconds; 0 disables
#wal_receiver_connect_retries = 1	# max retries that receiver connect master
#wal_receiver_buffer_size = 64MB	# wal receiver buffer size
#enable_xlog_prune = on # xlog keep for all standbys even through they are not connecting and donnot created replslot.
#max_size_for_xlog_prune = 2147483647  # xlog keep for the wal size less than max_xlog_size when the enable_xlog_prune is on
#max_logical_replication_workers = 4   # Maximum number of logical replication worker processes.
#max_sync_workers_per_subscription = 2   # Maximum number of table synchronization workers per subscription.

#------------------------------------------------------------------------------
# QUERY TUNING
#------------------------------------------------------------------------------

# - Planner Method Configuration -

#enable_bitmapscan = on
#enable_hashagg = on
#enable_sortgroup_agg = off
#enable_hashjoin = on
#enable_indexscan = on
#enable_indexonlyscan = on
#enable_material = on
#enable_mergejoin = on
#enable_nestloop = on
#enable_seqscan = on
#enable_sort = on
#enable_tidscan = on
enable_kill_query = off			# optional: [on, off], default: off
# - Planner Cost Constants -

#seq_page_cost = 1.0			# measured on an arbitrary scale
#random_page_cost = 4.0			# same scale as above
#cpu_tuple_cost = 0.01			# same scale as above
#cpu_index_tuple_cost = 0.005		# same scale as above
#cpu_operator_cost = 0.0025		# same scale as above
#effective_cache_size = 128MB
#var_eq_const_selectivity = off

# - Genetic Query Optimizer -

#geqo = on
#geqo_threshold = 12
#geqo_effort = 5			# range 1-10
#geqo_pool_size = 0			# selects default based on effort
#geqo_generations = 0			# selects default based on effort
#geqo_selection_bias = 2.0		# range 1.5-2.0
#geqo_seed = 0.0			# range 0.0-1.0

# - Other Planner Options -

#default_statistics_target = 100	# range 1-10000
#constraint_exclusion = partition	# on, off, or partition
#cursor_tuple_fraction = 0.1		# range 0.0-1.0
#from_collapse_limit = 8
#join_collapse_limit = 8		# 1 disables collapsing of explicit
					# JOIN clauses
#plan_mode_seed = 0         # range -1-0x7fffffff
#check_implicit_conversions = off
#enable_expr_fusion = off
#enable_functional_dependency = off
#enable_indexscan_optimization = off
#enable_inner_unique_opt = off

#------------------------------------------------------------------------------
# ERROR REPORTING AND LOGGING
#------------------------------------------------------------------------------

# - Where to Log -

#log_destination = 'stderr'		# Valid values are combinations of
					# stderr, csvlog, syslog, and eventlog,
					# depending on platform.  csvlog
					# requires logging_collector to be on.

# This is used when logging to stderr:
logging_collector = on   		# Enable capturing of stderr and csvlog
					# into log files. Required to be on for
					# csvlogs.
					# (change requires restart)

# These are only used if logging_collector is on:
#log_directory = 'pg_log'		# directory where log files are written,
					# can be absolute or relative to PGDATA
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'	# log file name pattern,
					# can include strftime() escapes
log_file_mode = 0600			# creation mode for log files,
					# begin with 0 to use octal notation
#log_truncate_on_rotation = off		# If on, an existing log file with the
					# same name as the new log file will be
					# truncated rather than appended to.
					# But such truncation only occurs on
					# time-driven rotation, not on restarts
					# or size-driven rotation.  Default is
					# off, meaning append to existing files
					# in all cases.
#log_rotation_age = 1d			# Automatic rotation of logfiles will
					# happen after that time.  0 disables.
log_rotation_size = 20MB		# Automatic rotation of logfiles will
					# happen after that much log output.
					# 0 disables.

# These are relevant when logging to syslog:
#syslog_facility = 'LOCAL0'
#syslog_ident = 'postgres'

# This is only relevant when logging to eventlog (win32):
#event_source = 'PostgreSQL'

# - When to Log -

#log_min_messages = warning		# values in order of decreasing detail:
					#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
					#   info
					#   notice
					#   warning
					#   error
					#   log
					#   fatal
					#   panic

#log_min_error_statement = error	# values in order of decreasing detail:
				 	#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
				 	#   info
					#   notice
					#   warning
					#   error
					#   log
					#   fatal
					#   panic (effectively off)

log_min_duration_statement = 1800000	# -1 is disabled, 0 logs all statements
					# and their durations, > 0 logs only
					# statements running at least this number
					# of milliseconds


# - What to Log -

#debug_print_parse = off
#debug_print_rewritten = off
#debug_print_plan = off
#debug_pretty_print = on
#log_checkpoints = off
#log_pagewriter = off
log_connections = off			# log connection requirement from client
log_disconnections = off		# log disconnection from client
log_duration = off			# log the execution time of each query
					# when log_duration is on and log_min_duration_statement
					# is larger than zero, log the ones whose execution time
					# is larger than this threshold
#log_error_verbosity = default		# terse, default, or verbose messages
log_hostname = off			# log hostname
log_line_prefix = '%m %u %d %h %p %S '	# special values:
					#   %a = application name
					#   %u = user name
					#   %d = database name
					#   %r = remote host and port
					#   %h = remote host
					#   %p = process ID
					#   %t = timestamp without milliseconds
					#   %m = timestamp with milliseconds
					#   %n = DataNode name
					#   %i = command tag
					#   %e = SQL state
					#   %c = logic thread ID
					#   %l = session line number
					#   %s = session start timestamp
					#   %v = virtual transaction ID
					#   %x = transaction ID (0 if none)
					#   %q = stop here in non-session
					#        processes
					#   %S = session ID
					#   %% = '%'
					# e.g. '<%u%%%d> '
#log_lock_waits = off			# log lock waits >= deadlock_timeout
#log_statement = 'none'			# none, ddl, mod, all
#log_temp_files = -1			# log temporary files equal or larger
					# than the specified size in kilobytes;
					# -1 disables, 0 logs all temp files
log_timezone = 'PRC'

#------------------------------------------------------------------------------
# ALARM
#------------------------------------------------------------------------------
enable_alarm = on
connection_alarm_rate = 0.9
alarm_report_interval = 10
alarm_component = '/opt/snas/bin/snas_cm_cmd'

#------------------------------------------------------------------------------
# RUNTIME STATISTICS
#------------------------------------------------------------------------------

# - Query/Index Statistics Collector -

#track_activities = on
#track_counts = on
#track_io_timing = off
#track_functions = none			# none, pl, all
#track_activity_query_size = 1024 	# (change requires restart)
#update_process_title = on
#stats_temp_directory = 'pg_stat_tmp'
#track_thread_wait_status_interval = 30min # 0 to disable
#track_sql_count = off
#enbale_instr_track_wait = on

# - Statistics Monitoring -

#log_parser_stats = off
#log_planner_stats = off
#log_executor_stats = off
#log_statement_stats = off

#------------------------------------------------------------------------------
# WORKLOAD MANAGER
#------------------------------------------------------------------------------

use_workload_manager = on		# Enables workload manager in the system.
					# (change requires restart)
#------------------------------------------------------------------------------
# SECURITY POLICY
#------------------------------------------------------------------------------
#enable_security_policy = off
#use_elastic_search = off
#elastic_search_ip_addr = 'https://127.0.0.1' # what elastic search ip is, change https to http when elastic search is non-ssl mode


#cpu_collect_timer = 30

#------------------------------------------------------------------------------
# AUTOVACUUM PARAMETERS
#------------------------------------------------------------------------------

#autovacuum = off			# Enable autovacuum subprocess?  default value is 'on'
					# requires track_counts to also be on.
#log_autovacuum_min_duration = -1	# -1 disables, 0 logs all actions and
					# their durations, > 0 logs only
					# actions running at least this number
					# of milliseconds.
#autovacuum_max_workers = 3		# max number of autovacuum subprocesses
					# (change requires restart)
#autovacuum_naptime = 1min		# time between autovacuum runs
#autovacuum_vacuum_threshold = 50	# min number of row updates before
					# vacuum
#autovacuum_analyze_threshold = 50	# min number of row updates before
					# analyze
#autovacuum_vacuum_scale_factor = 0.2	# fraction of table size before vacuum
#autovacuum_analyze_scale_factor = 0.1	# fraction of table size before analyze
#autovacuum_freeze_max_age = 200000000	# maximum XID age before forced vacuum
					# (change requires restart)
#autovacuum_vacuum_cost_delay = 20ms	# default vacuum cost delay for
					# autovacuum, in milliseconds;
					# -1 means use vacuum_cost_delay
#autovacuum_vacuum_cost_limit = -1	# default vacuum cost limit for
					# autovacuum, -1 means use
					# vacuum_cost_limit

#------------------------------------------------------------------------------
# AI-based Optimizer
#------------------------------------------------------------------------------
# enable_ai_stats = on           # Enable AI Ext Statistics? default value is 'on'

#------------------------------------------------------------------------------
# CLIENT CONNECTION DEFAULTS
#------------------------------------------------------------------------------

# - Statement Behavior -
#client_min_messages = notice      # values in order of decreasing detail:
                   #   debug5
                   #   debug4
                   #   debug3
                   #   debug2
                   #   debug1
                   #   log
                   #   notice
                   #   warning
                   #   error
#search_path = '"$user",public'		# schema names
#default_tablespace = ''		# a tablespace name, '' uses the default
#temp_tablespaces = ''			# a list of tablespace names, '' uses
					# only default tablespace
#check_function_bodies = on
#default_transaction_isolation = 'read committed'
#default_transaction_read_only = off
#default_transaction_deferrable = off
#session_replication_role = 'origin'
#statement_timeout = 0			# in milliseconds, 0 is disabled
#vacuum_freeze_min_age = 50000000
#vacuum_freeze_table_age = 150000000
#bytea_output = 'hex'			# hex, escape
#block_encryption_mode = 'aes-128-cbc'     #  values in order of decreasing detail:
    #  aes-128-cbc
    #  aes-192-cbc
    #  aes-256-cbc
    #  aes-128-cfb1
    #  aes-192-cfb1
    #  aes-256-cfb1
    #  aes-128-cfb8
    #  aes-192-cfb8
    #  aes-256-cfb8
    #  aes-128-cfb128
    #  aes-192-cfb128
    #  aes-256-cfb128
    #  aes-128-ofb
    #  aes-192-ofb
    #  aes-256-ofb
#xmlbinary = 'base64'
#xmloption = 'content'
#max_compile_functions = 1000
#gin_pending_list_limit = 4MB
#group_concat_max_len=1024
# - Locale and Formatting -

datestyle = 'iso, mdy'
#intervalstyle = 'postgres'
timezone = 'PRC'
#timezone_abbreviations = 'Default'     # Select the set of available time zone
					# abbreviations.  Currently, there are
					#   Default
					#   Australia
					#   India
					# You can create your own file in
					# share/timezonesets/.
#extra_float_digits = 0			# min -15, max 3
#client_encoding = sql_ascii		# actually, defaults to database
					# encoding

# These settings are initialized by initdb, but they can be changed.
lc_messages = 'en_US.utf8'			# locale for system error message
					# strings
lc_monetary = 'en_US.utf8'			# locale for monetary formatting
lc_numeric = 'en_US.utf8'			# locale for number formatting
lc_time = 'en_US.utf8'				# locale for time formatting

# default configuration for text search
default_text_search_config = 'pg_catalog.english'

# - Other Defaults -

#dynamic_library_path = '$libdir'
#local_preload_libraries = ''

#------------------------------------------------------------------------------
# LOCK MANAGEMENT
#------------------------------------------------------------------------------

#deadlock_timeout = 1s
lockwait_timeout = 1200s		# Max of lockwait_timeout and deadlock_timeout + 1s
#max_locks_per_transaction = 256		# min 10
					# (change requires restart)
# Note:  Each lock table slot uses ~270 bytes of shared memory, and there are
# max_locks_per_transaction * (max_connections + max_prepared_transactions)
# lock table slots.
#max_pred_locks_per_transaction = 64	# min 10
					# (change requires restart)

#------------------------------------------------------------------------------
# VERSION/PLATFORM COMPATIBILITY
#------------------------------------------------------------------------------

# - Previous openGauss Versions -

#array_nulls = on
#backslash_quote = safe_encoding	# on, off, or safe_encoding
#default_with_oids = off
#escape_string_warning = on
#lo_compat_privileges = off
#quote_all_identifiers = off
#sql_inheritance = on
#standard_conforming_strings = on
#synchronize_seqscans = on

# - Other Platforms and Clients -

#transform_null_equals = off

##------------------------------------------------------------------------------
# ERROR HANDLING
#------------------------------------------------------------------------------

#exit_on_error = off			# terminate session on any error?
#restart_after_crash = on		# reinitialize after backend crash?
#omit_encoding_error = off		# omit untranslatable character error
#data_sync_retry = off			# retry or panic on failure to fsync data?

#------------------------------------------------------------------------------
# DATA NODES AND CONNECTION POOLING
#------------------------------------------------------------------------------
#cache_connection = on          # pooler cache connection

#------------------------------------------------------------------------------
# GTM CONNECTION
#------------------------------------------------------------------------------

pgxc_node_name = 'helmdb'			# Coordinator or Datanode name
					# (change requires restart)

##------------------------------------------------------------------------------
# OTHER PG-XC OPTIONS
#------------------------------------------------------------------------------
#enforce_two_phase_commit = on		# Enforce the usage of two-phase commit on transactions
					# where temporary objects are used or ON COMMIT actions
					# are pending.
					# Usage of commit instead of two-phase commit may break
					# data consistency so use at your own risk.

#------------------------------------------------------------------------------
# AUDIT
#------------------------------------------------------------------------------

audit_enabled = on
#audit_directory = 'pg_audit'
#audit_data_format = 'binary'
#audit_rotation_interval = 1d
#audit_rotation_size = 10MB
#audit_space_limit = 1024MB
#audit_file_remain_threshold = 1048576
#audit_login_logout = 7
#audit_database_process = 1
#audit_user_locked = 1
#audit_user_violation = 0
#audit_grant_revoke = 1
#audit_system_object = 12295
#audit_dml_state = 0
#audit_dml_state_select = 0
#audit_function_exec = 0
#audit_copy_exec = 0
#audit_set_parameter = 1		# whether audit set parameter operation
#audit_xid_info = 0 			# whether record xid info in audit log
#audit_thread_num = 1
#no_audit_client = ""
#full_audit_users = ""
#audit_system_function_exec = 0

#Choose which style to print the explain info, normal,pretty,summary,run
#explain_perf_mode = normal
#------------------------------------------------------------------------------
# CUSTOMIZED OPTIONS
#------------------------------------------------------------------------------

# Add settings for extensions here

# ENABLE DATABASE PRIVILEGES SEPARATE
#------------------------------------------------------------------------------
#enableSeparationOfDuty = off
#------------------------------------------------------------------------------


#enable_fast_allocate = off
#prefetch_quantity = 32MB
#backwrite_quantity = 8MB
#cstore_prefetch_quantity = 32768		#unit kb
#cstore_backwrite_quantity = 8192		#unit kb
#cstore_backwrite_max_threshold =  2097152		#unit kb
#fast_extend_file_size = 8192		#unit kb

#------------------------------------------------------------------------------
# LLVM
#------------------------------------------------------------------------------
#enable_codegen = off			# consider use LLVM optimization
#enable_codegen_print = off		# dump the IR function
#codegen_cost_threshold = 10000		# the threshold to allow use LLVM Optimization

#------------------------------------------------------------------------------
# JOB SCHEDULER OPTIONS
#------------------------------------------------------------------------------
job_queue_processes = 10        # Number of concurrent jobs, optional: [0..1000], default: 10.

#------------------------------------------------------------------------------
# DCF OPTIONS
#------------------------------------------------------------------------------
#enable_dcf = off
#
#------------------------------------------------------------------------------
# PLSQL COMPILE OPTIONS
#------------------------------------------------------------------------------
#plsql_show_all_error=off
#enable_seqscan_fusion = off
#enable_cachedplan_mgr=on
#enable_ignore_case_in_dquotes=off

#------------------------------------------------------------------------------
# SHARED STORAGE OPTIONS
#------------------------------------------------------------------------------
#ss_enable_dms = off
#ss_enable_dss = off
#ss_enable_ssl = on
#ss_enable_aio = on
#ss_enable_catalog_centralized = on
#ss_instance_id = 0
#ss_dss_vg_name = ''
#ss_dss_conn_path = ''
#ss_interconnect_channel_count = 16
#ss_work_thread_count = 32
#ss_recv_msg_pool_size = 16MB
#ss_interconnect_type = 'TCP'
#ss_interconnect_url = '0:127.0.0.1:1611'
#ss_rdma_work_config = ''
#ss_ock_log_path = ''
#ss_enable_scrlock = off
#ss_enable_scrlock_sleep_mode = on
#ss_scrlock_server_port = 8000
#ss_scrlock_worker_count = 2
#ss_scrlock_worker_bind_core = ''
#ss_scrlock_server_bind_core = ''
#ss_log_level = 7
#ss_log_backup_file_count = 10
#ss_log_max_file_size = 10MB
#ss_parallel_thread_count = 16
#ss_enable_ondemand_recovery = off
#ss_ondemand_recovery_mem_size = 4GB     # min: 1GB, max: 100GB
#ss_enable_ondemand_realtime_build = off
#ss_enable_dorado = off
#ss_stream_cluster = off
#enable_segment = off
#ss_work_thread_pool_attr = ''

#------------------------------------------------------------------------------
# UWAL OPTIONS
#------------------------------------------------------------------------------
#enable_uwal = off
#uwal_disk_size = 8589934592
#uwal_devices_path = 'uwal_device_file'
#uwal_log_path = 'uwal_log'
#uwal_rpc_compression_switch = false
#uwal_rpc_flowcontrol_switch = false
#uwal_rpc_flowcontrol_value = 128
#uwal_config = '{"uwal_nodeid": 0, "uwal_ip": "127.0.0.1", "uwal_port": 9991, "uwal_protocol": "tcp", "cpu_bind_switch": "true", "cpu_bind_start": 1, "cpu_bind_num": 3}'

# These settings must be set when enable_uwal is on by standby node, 
# and it be add in ANY params in synchronous_standby_names by primary node.

#application_name = 'dn_master'
#enable_nls = off

```

3. 启动数据库

```shell
gs_ctl start -D /home/pyw/data/helmdb_data -Z single_node -l logfile
```

#### <font style="color:#000000;">关闭</font>
```shell
gs_ctl stop -D /home/pyw/data/helmdb_data -m immediate
```

## <font style="color:#000000;">4.2数据加载</font>
<font style="color:#000000;">将M2Bench数据集分别导入到 HelmDB 和 ArangoDB 中。</font>

<font style="color:#000000;">假设M2bench的数据目录位于</font>`**<font style="color:#000000;">/test/m2bench/Datasets</font>**`

<font style="color:#000000;">测试脚本位于</font>`**<font style="color:#000000;">/test/m2bench/Impl</font>**`

### <font style="color:#000000;">ArangoDB导入</font>
+ <font style="color:#000000;">修改</font>`**<font style="color:#000000;">/test/m2bench/Impl/arangodb/load_datasets/load_all.sh</font>**`

`**<font style="color:#000000;">USERNAME</font>**`<font style="color:#000000;">和</font>`**<font style="color:#000000;">PASSWORD</font>**`<font style="color:#000000;">分别修改为4.1中设置的arangodb的用户名和密码，</font>`**<font style="color:#000000;">PORT</font>**`<font style="color:#000000;">修改为所在端口。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/28092607/1742108982645-69eef439-1f8b-4aaa-9e49-2ee3cac3709f.png)

+ <font style="color:#000000;">执行下列命令，将数据集导入arangodb：</font>

```shell
nohup bash /test/m2bench/Impl/arangodb/load_datasets/load_all.sh &
```

### <font style="color:#000000;">Helmdb导入</font>
`**<font style="color:#000000;">PORT</font>**`<font style="color:#000000;">修改为所在端口</font>

![](https://cdn.nlark.com/yuque/0/2025/png/28092607/1742110503311-bb679a8e-5913-4ea5-93c7-93d37eae5065.png)

```shell
nohup bash /test/m2bench/Impl/Helmdb/load_datasets/import.sh &
```

## <font style="color:#000000;">4.3 执行m2bench测试</font>
<font style="color:#000000;">根据 M2Bench规范执行一系列预定义的查询和操作。</font>

### **<font style="color:#000000;">ArangoDB执行</font>**
<font style="color:#000000;">先把</font>`<font style="color:#000000;">/test/m2bench/Impl/arangodb/run_tasks/run_all.sh</font>`<font style="color:#000000;"> 中的</font>`**<font style="color:#000000;">USERNAME</font>**`<font style="color:#000000;">和</font>`**<font style="color:#000000;">PASSWORD</font>**`<font style="color:#000000;">分别修改为4.1中设置的arangodb的用户名和密码。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/36173908/1734917390470-dc2e5080-72d7-4887-b3d0-a715c4d7fee9.png)

<font style="color:#000000;">然后执行以下命令：</font>

```shell
nohup bash /home/gauss/m2bench/Impl/arangodb/run_tasks/run_all.sh &
```

将在后台直接进行arangodb所有任务的测试，并将输出结果保存在`<font style="color:#000000;">/test/m2bench</font>/Impl/arangodb/log`文件中，在运行完成后可以查看。

### **<font style="color:#000000;">HelmDB执行</font>**
把`**PORT**`设置为对应端口

![](https://cdn.nlark.com/yuque/0/2025/png/28092607/1742110713392-7313b7a9-61e7-4450-8ed9-2d47f28a52ae.png)

```shell
nohup bash /home/gauss/m2bench/Impl/Helmdb/run_tasks/run_all.sh &
```

将在后台直接进行HelmDB所有任务的测试，并将输出结果保存在`<font style="color:#000000;">/test/m2bench</font>/Impl/helmdb/log`文件中，在运行完成后可以查看。

## <font style="color:#000000;">4.4 测试结果收集</font>
执行完测试后，测试相关的结果生成在对应数据库log目录下。log会按照不同的Topic分开，例：

```shell
/home/hlqiu/m2bench/Impl/helmdb/log/20250227203402_run_ecommerce_tasks.log
/home/hlqiu/m2bench/Impl/helmdb/log/20250227203415_run_healthcare_tasks.log
/home/hlqiu/m2bench/Impl/helmdb/log/20250227203433_run_disaster_tasks.log
```

其中会包含共17个Task的查询结果，每个查询的时间取real时间，例：

```shell
real	0m25.075s
user	0m0.011s
sys	0m0.008s
```

这里给出一版笔者的测试查询时间与答案对比供参考：

| **<font style="color:black;">Task</font>** | **<font style="color:black;">Result</font>** | **<font style="color:black;">ArangoDB(s)</font>** | **<font style="color:black;">HelmDB(s)</font>** | **<font style="color:black;">Acceleration Rate(Arango)</font>** |
| :---: | :---: | :---: | :---: | :---: |
| **<font style="color:black;">0</font>** | **<font style="color:black;">/</font>** | <font style="color:black;">327.414</font> | **<font style="color:red;">3.565</font>** | <font style="color:black;">9184%</font> |
| **<font style="color:black;">1</font>** | **<font style="color:black;">24</font>** | <font style="color:black;">1.692</font> | **<font style="color:red;">0.536</font>** | <font style="color:black;">316%</font> |
| **<font style="color:black;">2</font>** | **<font style="color:black;">/</font>** | <font style="color:black;">408.684</font> | **<font style="color:red;">11.983</font>** | <font style="color:black;">3411%</font> |
| **<font style="color:black;">3</font>** | **<font style="color:black;">3</font>** | <font style="color:black;">8.22</font> | **<font style="color:red;">1.118</font>** | <font style="color:black;">735%</font> |
| **<font style="color:black;">4</font>** | **<font style="color:black;">182</font>** | <font style="color:black;">1.879</font> | **<font style="color:red;">3.029</font>** | <font style="color:black;">62%</font> |
| **<font style="color:black;">5</font>** | **<font style="color:black;">2224</font>** | <font style="color:black;">0.464</font> | **<font style="color:red;">0.464</font>** | <font style="color:black;">100%</font> |
| **<font style="color:black;">6</font>** | **<font style="color:black;">3018</font>** | <font style="color:red;">1.043</font> | **<font style="color:black;">1.472</font>** | <font style="color:black;">71%</font> |
| **<font style="color:black;">7</font>** | **<font style="color:black;">2</font>** | <font style="color:black;">3.342</font> | **<font style="color:black;">5.441</font>** | <font style="color:black;">61%</font> |
| **<font style="color:black;">8</font>** | **<font style="color:black;">868</font>** | <font style="color:black;">2.591</font> | **<font style="color:red;">0.168</font>** | <font style="color:black;">1542%</font> |
| **<font style="color:black;">9</font>** | **<font style="color:black;">7726</font>** | <font style="color:black;">2041.718</font> | **<font style="color:red;">15.468</font>** | <font style="color:black;">13200%</font> |
| **<font style="color:black;">10</font>** | **<font style="color:black;">11890</font>** | <font style="color:black;">37.421</font> | **<font style="color:red;">31.797</font>** | <font style="color:black;">118%</font> |
| **<font style="color:black;">11</font>** | **<font style="color:black;">363</font>** | <font style="color:black;">2574.802</font> | **<font style="color:red;">143.114</font>** | <font style="color:black;">1799%</font> |
| **<font style="color:black;">12</font>** | **<font style="color:black;">5</font>** | <font style="color:red;">58.971</font> | **<font style="color:black;">63.632</font>** | <font style="color:black;">93%</font> |
| **<font style="color:black;">13</font>** | **<font style="color:black;">106</font>** | <font style="color:red;">26.916</font> | **<font style="color:black;">54.357</font>** | <font style="color:black;">50%</font> |
| **<font style="color:black;">14</font>** | **<font style="color:black;">2</font>** | <font style="color:black;">416.98</font> | **<font style="color:red;">173.7</font>** | <font style="color:black;">240%</font> |
| **<font style="color:black;">15</font>** | **<font style="color:black;">143</font>** | <font style="color:black;">428.171</font> | **<font style="color:red;">46.347</font>** | <font style="color:black;">924%</font> |
| **<font style="color:black;">16</font>** | **<font style="color:black;">141</font>** | <font style="color:black;">81.224</font> | **<font style="color:red;">50.221</font>** | <font style="color:black;">162%</font> |
| **<font style="color:black;">Ecommerce</font>** | | **<font style="color:black;">748.353</font>** | **<font style="color:black;">20.695</font>** | <font style="color:black;">3616%</font> |
| **<font style="color:black;">Healthcare</font>** | | **<font style="color:black;">2048.694</font>** | **<font style="color:black;">22.549</font>** | <font style="color:black;">9086%</font> |
| **<font style="color:black;">Disaster</font>** | | **<font style="color:black;">3624.485</font>** | **<font style="color:black;">563.168</font>** | <font style="color:black;">644%</font> |
| **<font style="color:black;">Total</font>** | | <font style="color:black;">6421.532</font> | <font style="color:black;">606.412</font> | <font style="color:black;">1059%</font> |


# <font style="color:#000000;">5. 附件</font>
## <font style="color:#000000;">1.M2bench数据集</font>
<font style="color:#000000;">Dataset文件夹，详细说明见该目录下的README。</font>

# <font style="color:#000000;">6.功能性测试</font>
本课题一共涉及到21个功能性测试，具体细则如下：

| **用例标志** | **测试指标项** | **测试要求** | **测试步骤** |
| --- | --- | --- | --- |
| FUN-913-01 | 图模型管理 | 支持在顶点/边类型上定义属性，支持对顶点/边类型属性的增加、修改、删除、查询等操作 | 1）创建图模型，图模型包含多种点类型，同时给点、边添加属性，确认图模型的信息与状态<br/>2）修改图模型（包括点、边、属性的增删改）<br/>3）删除图模型<br/>依次验证1-3操作之后，图模型的信息与状态 |
| FUN-913-02 | 数据类型 | 点边属性类型支持整数型、浮点型、字符型、布尔型、时间戳等数据类型 | 1）给图中的点边添加整型、浮点型、字符串类型、布尔型、日期型的属性<br/>2）对上述类型的数据进行修改<br/>3）对上述类型的数据进行删除<br/>依次验证 |
| FUN-913-03 | 顶点/边数据管理 | 支持对顶点/边数据的增加、修改、删除、查询等操作 | 1）创建图模型<br/>2）对顶点表的拓扑数据进行增删改查操作<br/>3）对边表的拓扑数据进行增删改查操作<br/>依次验证1-3操作之后，图模型的信息与状态 |
| FUN-913-05 | 属性索引 | 支持在顶点和边的属性上创建多种类型的索引，如，可通过索引提高查找和遍历的速度 | 1）属性支持BTREE索引、GIN索引、哈希索引、表达式索引、部分索引、复合索引以及全文索引<br/>2）对每种索引，在创建索引前执行相应的查询，记录时间<br/>3）创建相应的索引，记录创建索引的耗时<br/>4）再次执行步骤 2 中的查询，记录查询时间<br/>5）对比步骤 2和步骤4的耗时，检查索引是否生效<br/>6）对索引进行查询、删除操作 |
| FUN-913-07 | 查询语言 | 支持图查询语言MMSQL | 1）DDL详见9.1.3图模型管理能力中图模型管理的图模型创建操作（用例标志_FUN-913-01_）<br/>2）DML详见点边数据和属性的增删改查操作<br/>3）执行给定的图查询SQL文件，验证DQL<br/>4）预期结果：所有语句能够在数据库中正常执行并产生正确的结果。 |
| FUN-914-01 | 向量数据类型 | 支持vector数据类型 | 创建一个表TableVA，包含vector属性列 |
| FUN-914-02 | 向量维度 | 支持高维向量 | 创建一个表TableVB，包含维度为1000的vector属性列 |
| FUN-914-03 | 向量数据操作 | 支持对向量数据进行增删改查操作 | 1）在TableVA中，用insert语句插入2条包含向量的记录<br/>2）用select语句可以查询到TableVA中包含向量的2条记录<br/>3）用delete语句删除TableVA中第一条包含向量的记录，并用select语句显示TableVA中剩余的记录<br/>4）用update语句修改TableVA中记录的向量，并用select语句显示修改后的记录 |
| FUN-914-04 | 向量检索 | 支持对数据进行top-k近邻的检索 | 1）在TableVA中插入更多的记录<br/>2）给定查询向量，用select语句进行top-10近邻查询<br/>3）把2的查询结果与准确结果进行对比 |
| FUN-914-05 | 距离相似度计算方式 | 支持内积距离、欧式距离、余弦距离等常用距离相似度计算方式 | 采用内积距离、欧式距离、余弦距离重复上述向量检索的测试 |
| FUN-914-06 | 向量索引 | 支持创建、删除检索索引，并通过索引进行top-k近似近邻查询 | 1）在TableVA上创建向量索引<br/>2）给定查询向量，用select语句进行top-10近邻查询<br/>3）用explain语句观察上述2中select语句的执行方案，采用了向量索引<br/>4）删除TableVA的向量索引<br/>5）用explain语句观察上述2中select语句的执行方案，没有向量索引<br/> |
| FUN-915-01 | 文档数据类型<br/> | 支持document数据类型 | 创建一个表TableDoc，包含doc列 |
| FUN-915-02 | 文档数据操作 | 支持对文档的增删改查操作 | 1）创建文档表<br/>2）插入文档数据<br/>3）查询文档数据，验证2的插入操作生效<br/>4）更新文档数据<br/>5）再次查询验证4的操作生效<br/>6）删除文档数据<br/>7）再次查询验证6的操作生效 |
| FUN-915-03 | 文档索引 | 支持在doc列上创建多种索引，加速文档查询 | 1）doc列支持BTREE索引、GIN索引、哈希索引、表达式索引、部分索引、复合索引以及全文索引<br/>2）对每种索引，在创建索引前执行相应的查询，记录时间<br/>3）创建相应的索引，记录创建索引的耗时<br/>4）再次执行步骤 2 中的查询，记录查询时间<br/>5）对比步骤 2和步骤4的耗时，检查索引是否生效<br/>6）对索引执行查询和删除操作 |
| FUN-915-04 | 文档查询 | 支持通过路径表达式和解嵌套UNNEST文档查询操作 | 1）执行路径表达式查询语句<br/>2）执行解嵌套查询语句<br/>3）验证1和2的结果是否符合预期 |
| FUN-915-05 | 文档模型转化 | todoc关键字将查询结果转化为document | 1）执行包含todoc的查询语句<br/>2）验证查询结果是否输出为json文档 |
| FUN-916-01 | 跨模查询 | 提供跨模查询的数据关联模型，支持关系、大图、向量、文档的跨模关联查询 | 1）准备相关测试数据并导入数据库<br/>2）执行关系、图、向量和文档模型两两跨模关联查询、三个模型跨模关联查询以及四个模型的跨模查询语句<br/>3）验证所有语句是否能够正常执行以及结果是否符合预期 |
| FUN-916-02 | 跨模查询语言 | 支持基于标准SQL的关系、大图、向量、文档的跨模查询语言 | 详见MMSQL查询语句 |
| FUN-916-03 | 跨模查询引擎 | 支持关系、大图、向量、文档的跨模执行引擎 | 用Explain关键字执行关系、图、向量以及文档的跨模查询语句，验证查询计划中是否有相应四个模型的算子 |
| FUN-916-04 | 基于跨模代价估计模型的查询优化方法 | 支持关系、大图、向量、文档的跨模代价估计模型 | 用Explain关键字执行关系、图、向量以及文档的跨模查询语句，验证查询计划中是否对各个算子进行了代价估计<br/> |
| FUN-916-05 | 基于硬件资源感知的跨模查询优化方法 | 支持基于硬件资源感知的关系、大图、向量的跨模查询优化方法 | 1）编译选项中启用GPU新硬件的支持<br/>2）完成编译安装后执行_FUN-916-04_中的查询语句<br/>3）通过Explain查看查询计划是否自动调用了GPU算子 |


<font style="color:#000000;">上述每一个测试用例都对应于本仓库functional_test文件夹下的sql文件：</font>

+ <font style="color:#000000;">其中</font>_FUN-913-07_, _FUN-916-01_与_FUN-916-02_可在M2Bench测试中体现，所以不再重复测试
+ _FUN-916-03_～_FUN-916-05_可以使用M2Bench中的Task11进行测试，所以该三个测试用例需要连接到M2Bench测试中的Disaster数据库进行
+ _FUN-913-05_同_FUN-915-03_，固_FUN-913-05_不再重复测试
+ 其余测试用例只需要连接到任意一个空的数据库即可进行