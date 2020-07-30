#!/bin/bash

now=$(date '+%Y%m%d%H%M')

(

start=$(date '+%s')

source /etc/rht

# classroom.example.com/content/courses/do380/ocp4.4/grading-scripts/
URL=classroom.example.com/content/courses/${RHT_COURSE}/${RHT_VMTREE%/x86_64}/grading-scripts/

# From Answer 14:
# https://stackoverflow.com/questions/1881237/easiest-way-to-extract-the-urls-from-an-html-page-using-sed-or-awk-only
#curl -s ${URL} | grep '<a href="lab-' \
#  | sed 's/<a href/\n<a href/g'  \
#  | sed 's/\"/\"><\/a>\n/2' \
#  | grep href | sort | uniq

LABS=$(curl -s ${URL} | grep '<a href="lab-' \
  | sed 's/<a href="lab-/\nlab-/g'  \
  | sed 's/\">/\n/g' \
  | grep -v '</a>' | grep 'lab-' | sort | uniq)

ctotal=0
cpass=0
cerr=0
laberr=""

for script in $LABS
do
	echo "***"
	echo "*** Testing lab script: $script"
	echo "***"
	lab="${script#lab-}"
	let ctotal=ctotal+1
	if lab $lab start 
	then
		echo "*** $lab start PASS"
		let cpass=cpass+1
	else
		echo "*** $lab start ERROR"
		let cerr=cerr+1
		laberr="$laberr $lab"
	fi
	
	sleep 5

	if lab $lab finish
	then
		echo "*** $lab finish PASS"
		let cpass=cpass+1
	else
		echo "*** $lab finish ERROR"
		let cerr=cerr+1
		laberr="$laberr $lab"
	fi
	
	sleep 5
done

end=$(date '+%s')
let interval=end-start

echo "***"
echo "*** Testing took $(date --utc --date=@$interval +%H:%M.%S) hr:min.seg"
echo "***"
echo "*** Total lab scripts: $ctotal, $cpass pass, $cerr errors"
echo "***"
echo "*** List of lab scripts with errors on either start or finish:"
echo -n "*** " ; echo $laberr | uniq

) 2>&1 3>&1 | tee lab-test-all-$now.log  | grep "\*\*\*"
