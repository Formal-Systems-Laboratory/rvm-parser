kompile ../../src/rvm/rvm-syntax.k --syntax-module RVM-SYNTAX

for i in `find property-db -name "*.rvm"`; do
	echo ===========================
	echo $i:
	cat $i;
	kast -d ../../src/rvm -s RVM $i

 done

