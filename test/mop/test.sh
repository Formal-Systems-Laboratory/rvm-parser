kompile ../../src/mop/mop-syntax.k --syntax-module MOP-SYNTAX

for i in `find property-db -name "*.mop"`; do
	echo ===========================
	echo $i:
	cat $i;
	kast -d ../../src/mop -s MOP $i

 done

