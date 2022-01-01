verilator --cc top.v -exe test_bench.cpp
make -C obj_dir/ -f Vtop.mk
./obj_dir/Vtop