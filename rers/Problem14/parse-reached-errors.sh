echo -e ".-------------------------------"
echo -e "| Parsing errors from KLEE output in 'klee-last'... "
echo -e "|-------------------------------"

cat $(ls klee-last | grep assert.err | awk '{print "klee-last/" $0}') | grep -o 'i=.*' | sed 's/i=\(.*\)).*/\1/' | sort -u -n > errors.txt

echo -e "| Done! See 'errors.txt' for a list of the error states"
echo -e "| that have been reached. "
echo -e "'-------------------------------"