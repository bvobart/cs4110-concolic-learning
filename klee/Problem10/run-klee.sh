echo -e ".-------------------------------"
echo -e "| This script should be run inside the KLEE Docker container."
echo -e "|-------------------------------"
echo -e "| Compiling Problem10-KLEE.c for KLEE..."
echo -e "'-------------------------------"
clang -I /home/klee/klee_src/include -emit-llvm -g -c Problem10-KLEE.c -o Problem10-KLEE.bc
echo -e ".-------------------------------"
echo -e "| Compiled. Running KLEE..."
echo -e "'-------------------------------"
klee --allow-external-sym-calls --emit-all-errors Problem10-KLEE.bc | tee /dev/tty | grep error > errors.txt
