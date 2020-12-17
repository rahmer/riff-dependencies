SAVEDCWD=`pwd`

cd OUTPUT

for largefile in `find . -maxdepth 1 -type f -size +95M | sed 's/^\.\///'`
do
	echo "processing file: " ${largefile} "..."
	split -b95M ${largefile} parts_${largefile}
	mv ${largefile} deleteme_${largefile}
done

cd ${SAVEDCWD}
