all: compile test1 test2

compile: ../../../../../src/rvm/rvc.k
	kompile -d . ../../../../../src/rvm/rvc.k

__RVC_SeatBelt_Monitor.c: seatbelt.rvm
	krun seatbelt.rvm

test1: __RVC_SeatBelt_Monitor.c
	gcc test_1/seatbelt.c __RVC_SeatBelt_Monitor.c -o test1_k
	
test2: __RVC_SeatBelt_Monitor.c
	gcc test_2/seatbelt.c __RVC_SeatBelt_Monitor.c -o test2_k
	
clean:
	rm -f test1_k test2_k __RVC_* 

test: all
	-@./test1_k
	-@./test2_k
