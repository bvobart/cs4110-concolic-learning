# CS4110 SWTRE Assignment 2: Concolic & Learning

Repository for repeating our experiments done during assignment 2 of the CS4110 Software Testing and Reverse Engineering course of 2018.

The `rers` folder contains the RERS problems that we examined, with their respective adjusted source code to apply the tooling.

## Running KLEE

1. Make sure you have installed Docker.
2. Run `start-docker-klee.sh`. Note that the script will ask for Sudo access in order to use Docker.
3. In your KLEE Docker container, navigate to the folder of the problem that you want to examine.
4. Run the `run-klee.sh` script present in that directory.
5. Wait for an eternity for KLEE to finish...
