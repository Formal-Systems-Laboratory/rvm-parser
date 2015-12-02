rm -rf ../../src/mop/mop-syntax-kompiled
kompile ../../src/mop/mop-compiler.k 

for i in `find property-db -name "*.mop"`; do
	echo ===========================
	echo $i:
	cat $i;
	krun -d ../../src/mop $i -o kast

 done

