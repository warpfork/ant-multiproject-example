#!/bin/bash

function testProject {(
	PROJECT=$1
	DEPCOUNT=$2

	cd $PROJECT
	output=`ant`

	echo ====
	echo -n "project '$PROJECT' occurances of 'compile'    ...   "
	[ $DEPCOUNT -eq `echo "$output" | grep "^compile:$" -c` ] && echo "PASS" || echo "FAIL"
	echo -n "project '$PROJECT' occurances of 'dist'       ...   "
	[ $DEPCOUNT -eq `echo "$output" | grep "^dist:$" -c` ] && echo "PASS" || echo "FAIL"
	echo -n "project '$PROJECT' occurances of 'delegate.*' ...   "
	[ $DEPCOUNT -eq `echo "$output" | grep "^delegate." -c` ] && echo "PASS" || echo "FAIL"
	echo ====
	echo
)}

testProject web 3
testProject admin 3
testProject model 2
testProject utilities 1
testProject . 4


