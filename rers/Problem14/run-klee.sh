echo -e "-------------------------------"
echo -e "This script should be run inside the KLEE Docker container."
echo -e "-------------------------------"
echo -e "Compiling Problem14-KLEE.c for KLEE..."
echo -e "-------------------------------"
clang -I /home/klee/klee_src/include -emit-llvm -g -c Problem14-KLEE.c -o Problem14-KLEE.bc
echo -e "-------------------------------"
echo -e "Compiled. Running KLEE..."
echo -e "-------------------------------"
klee --allow-external-sym-calls --emit-all-errors Problem14-KLEE.bc
