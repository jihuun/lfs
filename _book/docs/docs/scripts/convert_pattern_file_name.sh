#! /bin/bash
# convert pattern on the file name
# v 0.1.0

function do_convert {
	echo $a
	#TODO: mkd, md should be variable
	mv $a $(ls $a | sed -e 's/mkd/md/g')
}

cd $1
echo "Converting file name in the $(pwd)"

for a in $(ls)
do
        do_convert $a
done
