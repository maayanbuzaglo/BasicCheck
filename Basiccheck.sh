#!/bin/bash
folderName=$1 #
executeble=$2
comp="PASS"
memo="PASS"
thread="PASS"

cd "$folderName"

make &> output.txt
secssesfullMake=$?
if [ "$secssesfullMake" -gt 0 ]; then
echo '    Compilation     Memory leaks     thread race'
echo "        FAIL            FAIL             FAIL"
echo 7
exit 7
fi

valgrind --leak-check=full --error-exitcode=1 ./"$executeble" $@ &> output.txt
valgrindOut=$?

if [ "$valgrindOut" -gt 0 ]; then
valgrindOut=1
memo="FAIL"
fi

valgrind --tool=helgrind --error-exitcode=1 ./"$executeble" $@ &> output.txt
helgrindOut=$?

if [ "$helgrindOut" -gt 0 ]; then
helgrindOut=1
thread="FAIL"
fi

echo '    Compilation     Memory leaks     thread race'
echo "       $comp            $memo          $thread"
result="$((2#$secssesfullMake$valgrindOut$helgrindOut))"
echo "$result"
exit "$result"