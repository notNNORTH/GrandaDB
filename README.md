# GrandaDB
## 1. Introduction
GrandaDB is designed to support managing **g**raph, **r**el**a**tio**n**al, and **d**ocument models, while efficiently processing both graph-centric cross-model queries and **a**nalytical tasks within a unified MM**DB**. This repo holds the source code and scripts for reproducing the key experiments of our paper: *GrandaDB: A Unified Multi-model Database for Graph-centric Cross-model Query and Data Analysis*.

## 2. Overview
### 2.1 Repository Organization
```bash
.
├── Datasets		# datasets for m2bench
├── Impl			# data load methods and query tasks with SF = 1, 2, 5, 10
│   ├── agensgraph
│   ├── arangodb
│   └── grandadb
├── LICENSE
├── README.md
├── Tasks
├── functional_test	# functional tests for GrandaDB
└── postgresql.conf	# configure file for GrandaDB
```
### 2.2 Benchmark
We evaluate GrandaDB’s performance on graph-centric cross-model queries and analytical workloads using tasks from [M2Bench](https://github.com/snu-dbs/m2bench), and compare it against the state-of-the-art multi-model databases [ArangoDB](https://github.com/arangodb/arangodb) and [AgensGraph](https://github.com/skaiworldwide-oss/agensgraph). All required datasets are available at: https://github.com/snu-dbs/m2bench.
### 2.3 Experiment Environment
**Hardware:**
- CPU：Intel(R) Xeon(R) Gold 5320 CPU @ 2.20GHz (*2)
- 512GB of DDR4 memory
- Samsung SSD 870 3.7TB

**Software:**
- Operating system: CentOS Linux release 8.5.2111
- Auxiliary tools: nmon/vmstat

## 3. System Deployment
We only provide the deployment process for GrandaDB. For ArangoDB and AgensGraph, readers can refer to their official deployment guides. Before starting, create a new directory for GrandaDB: `mkdir granda`, and then navigate into the directory with `cd granda`.
### 3.1 GCC Installation
- Download, compile, and install:
	```bash
	mkdir local
	cd local
	# Download and decompress the source code of GCC 10.3
	wget https://ftp.gnu.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.gz
	tar -xzf gcc-10.3.0.tar.gz

	# Install the dependencies required for GCC
	cd gcc-10.3.0
	./contrib/download_prerequisites

	# Create a build directory and configure the build options
	mkdir build
	cd build
	../configure --prefix=$HOME/granda/local/gcc-10.3 --disable-multilib --enable-languages=c,c++,fortran

	# Compile and install
	make -j$(nproc)
	make install -sj
	```
- Modify the environment variable file for GCC: run `nano ~/.bashrc` and add the following lines:
	```bash
	# gcc
	export GCC_PATH=$HOME/granda/local/gcc-10.3
	export CC=$GCC_PATH/bin/gcc
	export CXX=$GCC_PATH/bin/g++
	export LD_LIBRARY_PATH=$GCC_PATH/lib64:$LD_LIBRARY_PATH
	export PATH=$GCC_PATH/bin:$PATH
	```

### 3.2 GrandaDB Installation
- Get the [source code](https://edu.gitee.com/whudb/repos/whudb/HELMDB/sources) of GrandaDB.
- Get the third party binarylibs:
	```bash
	cd local
	wget https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz

	# decompress and rename the libs
	tar -zxvf openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz
	mv openGauss-third_party_binarylibs_Centos7.6_x86_64 binarylibs
	```
- Modify the environment variable file for GrandaDB: run `nano ~/.bashrc` and add the following lines:
	```bash
	# grandadb
	export BINARYLIBS=$HOME/granda/local/binarylibs
	export GRANDAHOME=$HOME/granda/GrandaDB
	export LD_LIBRARY_PATH=$GRANDAHOME/lib:$LD_LIBRARY_PATH
	export PATH=$GRANDAHOME/bin:$PATH
	```
- Go to `$GRANDAHOME` and run the `configure` command:
	```bash
	./configure --gcc-version=10.3.0 CC=g++ CFLAGS='-O3 -g3' --prefix=$GRANDAHOME --3rd=$BINARYLIBS --enable-thread-safety --with-readline --without-zlib
	```
- Compile and install:
	```bash
	make -sj64
	make install -sj64
	```
- Complie the operator library for GrandaDB:
	```bash
	cd contrib/ldbc
	make -sj
	make install -sj
	```
After installing GrandaDB, the PostGIS extension needs to be installed; details are available [here](https://docs.opengauss.org/zh/docs/6.0.0-RC1/docs/ExtensionReference/PostGIS%E5%AE%89%E8%A3%85.html).
  
### 3.3 Strat GrandaDB
- Initialize the data directory:
	```bash
	gs_initdb -D $GRANDAHOME/data --nodename="granda"
	```
- Enter the data directory and replace the `postgresql.conf` file with the version provided by this repository.
- Strat the database:
	```bash
	gs_ctl start -D $GRANDAHOME/data -Z single_node -l logfile
	```
- Stop the database:
	```bash
	gs_ctl stop -D $GRANDAHOME/data -m immediate
	```

## 4. Run Tasks
### 4.1 Data Loading
- Organize all the datasets within the format shown in the `Dataset/` directory.
- Load all the data by running `/path_to_repo/Impl/grandadb/load_datasets/impport.sh`. Before that, modify the `PORT` as what you set in the configure file.
	```bash
	nohup bash Impl/Helmdb/load_datasets/import.sh &
	```
### 4.2 Run Tasks
Modify the `PORT` as specified in the configuration file for the executable, and then run:
```bash
nohup bash /path_to_repo/Impl/grandadb/run_tasks/run_all.sh &
```
### 4.3 Collect the Results
After the tests are completed, the test-related results are generated in the log directory of the corresponding database. Logs are separated according to different topics. For example:
```bash
/path_to_repo/Impl/grandadb/log/20250227203402_run_ecommerce_tasks.log
/path_to_repo/Impl/grandadb/log/20250227203415_run_healthcare_tasks.log
/path_to_repo/Impl/grandadb/log/20250227203433_run_disaster_tasks.log
```
It will include the query results for a total of 17 tasks, with the query time taken as the `real` time. For example:

```bash
real	0m25.075s
user	0m0.011s
sys		0m0.008s
```
