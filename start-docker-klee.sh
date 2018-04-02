echo -e "-------------------------------"
echo -e "Retrieving KLEE Docker image..."
echo -e "-------------------------------\n"
sudo docker pull klee/klee
echo -e "\n-------------------------------"
echo -e "Running KLEE Docker image. rers folder is mounted to '~/rers'"
echo -e "-------------------------------\n"
sudo docker run -ti --rm --mount type=bind,source="$(pwd)"/klee,target=/home/klee/rers klee/klee
echo -e "Bye!"
