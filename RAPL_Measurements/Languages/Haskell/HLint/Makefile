# Variables
NTIMES      = 10
FILE_SMALL   = small.hs
FILE_MEDIUM  = medium.hs
FILE_LARGE   = large.hs

export NTIMES

# Define the GHC compiler (overridable externally)
GHC ?= ghc

# Directory structure
BUILD_DIR = build

# Ensure build directory exists
$(shell mkdir -p $(BUILD_DIR))

# Check if hlint is installed and install if necessary
check_hlint:
	@command -v hlint >/dev/null 2>&1 || (echo "Installing HLint..." && cabal install hlint)

# Compile HLint runner
compile_hlint: check_hlint
	$(GHC) -O0 -package hlint --make -o $(BUILD_DIR)/hlint_runner HLintRunner.hs

compile_hlint_O2: check_hlint
	$(GHC) -O2 -package hlint --make -o $(BUILD_DIR)/hlint_runner_O2 HLintRunner.hs

# Small test case
run_small: compile_hlint
	./$(BUILD_DIR)/hlint_runner $(FILE_SMALL)

run_small_O2: compile_hlint_O2
	./$(BUILD_DIR)/hlint_runner_O2 $(FILE_SMALL)

measure_small: compile_hlint
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner $(FILE_SMALL)" Haskell HLint_Small $(NTIMES)

measure_small: compile_hlint
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner $(FILE_SMALL)" Haskell HLint_Small $(NTIMES)

measure_small_O2: compile_hlint_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner_O2 $(FILE_SMALL)" Haskell HLint_Small $(NTIMES)

mem_small: compile_hlint
	{ /usr/bin/time -v ./$(BUILD_DIR)/hlint_runner $(FILE_SMALL) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_small_O2: compile_hlint_O2
	{ /usr/bin/time -v ./$(BUILD_DIR)/hlint_runner_O2 $(FILE_SMALL) > /dev/null; } 2>&1 | grep "Maximum resident"

# Medium test case
run_medium: compile_hlint
	./$(BUILD_DIR)/hlint_runner $(FILE_MEDIUM)

run_medium_O2: compile_hlint_O2
	./$(BUILD_DIR)/hlint_runner_O2 $(FILE_MEDIUM)

measure_medium: compile_hlint
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner $(FILE_MEDIUM)" Haskell HLint_Medium $(NTIMES)

measure_medium_O2: compile_hlint_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner_O2 $(FILE_MEDIUM)" Haskell HLint_Medium $(NTIMES)

mem_medium: compile_hlint
	{ /usr/bin/time -v ./$(BUILD_DIR)/hlint_runner $(FILE_MEDIUM) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_medium_O2: compile_hlint_O2
	{ /usr/bin/time -v ./$(BUILD_DIR)/hlint_runner_O2 $(FILE_MEDIUM) > /dev/null; } 2>&1 | grep "Maximum resident"

# Large test case
run_large: compile_hlint
	./$(BUILD_DIR)/hlint_runner $(FILE_LARGE)

run_large_O2: compile_hlint_O2
	./$(BUILD_DIR)/hlint_runner_O2 $(FILE_LARGE)

measure_large: compile_hlint
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner $(FILE_LARGE)" Haskell HLint_Large $(NTIMES)

measure_large_O2: compile_hlint_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/hlint_runner_O2 $(FILE_LARGE)" Haskell HLint_Large $(NTIMES)

mem_large: compile_hlint
	{ /usr/bin/time -v ./$(BUILD_DIR)/hlint_runner $(FILE_LARGE) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_large_O2: compile_hlint_O2
	{ /usr/bin/time -v ./$(BUILD_DIR)/hlint_runner_O2 $(FILE_LARGE) > /dev/null; } 2>&1 | grep "Maximum resident"

# Run all measurements
measure_all: measure_small measure_medium measure_large

measure_all_O2: measure_small_O2 measure_medium_O2 measure_large_O2

# Cleanup
clean:
	rm -rf $(BUILD_DIR)
	rm -f *.o *.hi measurements.csv

.PHONY: install_hlint compile_hlint compile_hlint_O2 \
        run_small run_small_O2 measure_small measure_small_O2 mem_small mem_small_O2 \
        run_medium run_medium_O2 measure_medium measure_medium_O2 mem_medium mem_medium_O2 \
        run_large run_large_O2 measure_large measure_large_O2 mem_large mem_large_O2 \
        measure_all measure_all_O2 clean