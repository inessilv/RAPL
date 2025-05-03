NTIMES=10
FACTORIAL=20

export NTIMES

compile:
	/usr/bin/gcc -O2 factorial.c -o factorial_run
	
measure:
	sudo modprobe msr
	sudo ../../../RAPL/main "./factorial_run $(FACTORIAL)" C factorial $(NTIMES)

run:
	./factorial_run $(FACTORIAL)

mem: 
	{ /usr/bin/time -v ./factorial_run $(FACTORIAL) > /dev/null; } 2>&1 | grep "Maximum resident" #| sed "s/[^0-9]\+\([0-9]\+\).*/\1/"

clean:
	rm -f factorial_run