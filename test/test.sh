kompile ../src/rvm-syntax.k --syntax-module RVM-SYNTAX

for i in `find property-db -name "*.rvm"`; do
	echo ===========================
	echo $i:
	cat $i;
	kast -d ../src -s RVM $i

 done

