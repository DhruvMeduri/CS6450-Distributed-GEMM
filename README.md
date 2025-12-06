Compile commands:

g++ -O3 -std=c++17 pre_process.cpp mmio.c -o mtx2bin
g++ -O3 -std=c++17 preload_ab.cpp mmio.c -o compute
g++ -O3 -std=c++17 shardedA_sharedB.cpp mmio.c -o sharedB_compute
g++ -O3 -std=c++17 shardedA_diskB.cpp mmio.c -o discB_compute

To run all the three implementations with different number of processes:
``` 
bash ./src/runall.sh
```
