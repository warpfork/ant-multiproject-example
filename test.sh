#!/bin/bash

function testProject {(
	PROJECT=$1
	DEPCOUNT=$2

	cd $PROJECT
	output=`ant`

	echo ====
	echo -n "project '$PROJECT' occurances of 'compile'    ...   " ; echo "$output" | checkMatchCount "^compile:$" "$DEPCOUNT"
	echo -n "project '$PROJECT' occurances of 'dist'       ...   " ; echo "$output" | checkMatchCount "^dist:$"    "$DEPCOUNT"
	echo -n "project '$PROJECT' occurances of 'delegate.*' ...   " ; echo "$output" | checkMatchCount "^delegate." "$(($DEPCOUNT * 2 - 1))"
	echo ====
	echo
)}

function checkMatchCount {
	# stdin provides stream to match over
	PATTERN=$1
	NEXPECT=$2

	matches=`grep "$PATTERN"`
	nmatch=`echo "$matches" | wc -l`
	[ $NEXPECT -eq $nmatch ] && echo "PASS, $nmatch/$NEXPECT" || { echo "FAIL, $nmatch/$NEXPECT" ; echo "  actual matching outputs:" ; echo "$matches" | sed 's/^/    /' ; }
}

testProject web 3
testProject admin 3
testProject model 2
testProject utilities 1
testProject . 4


