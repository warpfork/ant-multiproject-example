#!/bin/bash

function testProject {(
	PROJECT=$1
	NPROJECT=$2
	NNODE=$3

	cd $PROJECT
	output=`ant dist`

	echo ====
	echo -n "project '$PROJECT' occurances of 'compile'    ...   " ; echo "$output" | checkMatchCount "^compile:$" "$NPROJECT"
	echo -n "project '$PROJECT' occurances of 'dist'       ...   " ; echo "$output" | checkMatchCount "^dist:$"    "$NNODE"
	echo -n "project '$PROJECT' occurances of 'delegate.*' ...   " ; echo "$output" | checkMatchCount "^delegate." "$(($NNODE * 2 - 1))"
	echo -n "project '$PROJECT' has all unique delegates   ...   " ; [ 0 -eq `echo "$output" | grep "^delegate." | sort | uniq -d | wc -l` ] && echo "PASS" || echo "FAIL"
	echo -n "project '$PROJECT' has all unique delegatedeps...   " ; [ 0 -eq `echo "$output" | grep "^delegate.*.dependencies:$" | sort | uniq -d | wc -l` ] && echo "PASS" || echo "FAIL"
	echo -n "project '$PROJECT' did one-time setup once    ...   " ; [ 1 -eq `echo "$output" | grep "performing one-time setup.$" | wc -l` ] && echo "PASS" || echo "FAIL"
	echo -n "project '$PROJECT' used macro repeatedly      ...   " ; [ 1 -lt `echo "$output" | grep "macrodef inherited.$" | wc -l` ] && echo "PASS" || echo "FAIL"
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

testProject web       3 3
testProject admin     3 3
testProject model     2 2
testProject utilities 1 1
testProject .         4 5


