# Variables
NTIMES = 10
FIBONUMBER = 45

export NTIMES

# Define the GHC compiler (overridable externally)
GHC ?= ghc

# Haskell source file
SRC = Fibonacci.hs

# Targets to compile the Haskell program
compile:
	$(GHC) -O0 $(SRC) -o Fibonacci

compile_O2:
	$(GHC) -O2 $(SRC) -o Fibonacci_O2

# Run targets
run: compile
	./Fibonacci $(FIBONUMBER)

run_O2: compile_O2
	./Fibonacci_O2 $(FIBONUMBER)

# Measurement targets
measure: compile
	sudo modprobe msr
	sudo ../../../RAPL/main "./Fibonacci $(FIBONUMBER)" Haskell Fibonacci $(NTIMES)

measure_O2: compile_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./Fibonacci_O2 $(FIBONUMBER)" Haskell Fibonacci $(NTIMES)

# Memory usage targets
mem: compile
	{ /usr/bin/time -v ./Fibonacci $(FIBONUMBER) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_O2: compile_O2
	{ /usr/bin/time -v ./Fibonacci_O2 $(FIBONUMBER) > /dev/null; } 2>&1 | grep "Maximum resident"

# Cleanup
clean:
	rm -f Fibonacci Fibonacci_O2 Fibonacci_opt *.o *.hi

.PHONY: compile compile_O2 run run_O2 measure measure_O2 mem mem_O2 clean
