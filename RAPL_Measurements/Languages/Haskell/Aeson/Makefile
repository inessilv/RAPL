# Variables
NTIMES      = 10
FILE_SMALL   = small.json
FILE_MEDIUM  = medium.json
FILE_LARGE   = large.json

export NTIMES

# Define the GHC compiler (overridable externally)
GHC ?= ghc

# Directory structure
BUILD_DIR = build

# Ensure build directory exists
$(shell mkdir -p $(BUILD_DIR))

# Check if aeson is installed and install if necessary
check_aeson:
	@if ! $(GHC) -e "import Data.Aeson" 2>/dev/null; then \
		echo "Installing Aeson..." && cabal install aeson; \
	fi

# Compile Aeson runner
compile_aeson: check_aeson
	$(GHC) -O0 -package aeson -package text -package bytestring --make -o $(BUILD_DIR)/aeson_runner AesonRunner.hs

compile_aeson_O2: check_aeson
	$(GHC) -O2 -package aeson -package text -package bytestring --make -o $(BUILD_DIR)/aeson_runner_O2 AesonRunner.hs

# Small test case
run_small: compile_aeson
	./$(BUILD_DIR)/aeson_runner $(FILE_SMALL)

run_small_O2: compile_aeson_O2
	./$(BUILD_DIR)/aeson_runner_O2 $(FILE_SMALL)

measure_small: compile_aeson
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/aeson_runner $(FILE_SMALL)" Haskell Aeson_Small $(NTIMES)

measure_small_O2: compile_aeson_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/aeson_runner_O2 $(FILE_SMALL)" Haskell Aeson_Small $(NTIMES)

mem_small: compile_aeson
	{ /usr/bin/time -v ./$(BUILD_DIR)/aeson_runner $(FILE_SMALL) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_small_O2: compile_aeson_O2
	{ /usr/bin/time -v ./$(BUILD_DIR)/aeson_runner_O2 $(FILE_SMALL) > /dev/null; } 2>&1 | grep "Maximum resident"

# Medium test case
run_medium: compile_aeson
	./$(BUILD_DIR)/aeson_runner $(FILE_MEDIUM)

run_medium_O2: compile_aeson_O2
	./$(BUILD_DIR)/aeson_runner_O2 $(FILE_MEDIUM)

measure_medium: compile_aeson
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/aeson_runner $(FILE_MEDIUM)" Haskell Aeson_Medium $(NTIMES)

measure_medium_O2: compile_aeson_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/aeson_runner_O2 $(FILE_MEDIUM)" Haskell Aeson_Medium $(NTIMES)

mem_medium: compile_aeson
	{ /usr/bin/time -v ./$(BUILD_DIR)/aeson_runner $(FILE_MEDIUM) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_medium_O2: compile_aeson_O2
	{ /usr/bin/time -v ./$(BUILD_DIR)/aeson_runner_O2 $(FILE_MEDIUM) > /dev/null; } 2>&1 | grep "Maximum resident"

# Large test case
run_large: compile_aeson
	./$(BUILD_DIR)/aeson_runner $(FILE_LARGE)

run_large_O2: compile_aeson_O2
	./$(BUILD_DIR)/aeson_runner_O2 $(FILE_LARGE)

measure_large: compile_aeson
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/aeson_runner $(FILE_LARGE)" Haskell Aeson_Large $(NTIMES)

measure_large_O2: compile_aeson_O2
	sudo modprobe msr
	sudo ../../../RAPL/main "./$(BUILD_DIR)/aeson_runner_O2 $(FILE_LARGE)" Haskell Aeson_Large $(NTIMES)

mem_large: compile_aeson
	{ /usr/bin/time -v ./$(BUILD_DIR)/aeson_runner $(FILE_LARGE) > /dev/null; } 2>&1 | grep "Maximum resident"

mem_large_O2: compile_aeson_O2
	{ /usr/bin/time -v ./$(BUILD_DIR)/aeson_runner_O2 $(FILE_LARGE) > /dev/null; } 2>&1 | grep "Maximum resident"

# Run all measurements
measure_all: measure_small measure_medium measure_large

measure_all_O2: measure_small_O2 measure_medium_O2 measure_large_O2

# Cleanup
clean:
	rm -rf $(BUILD_DIR)
	rm -f *.o *.hi measurements.csv temp_output.json

.PHONY: check_aeson compile_aeson compile_aeson_O2 \
        run_small run_small_O2 measure_small measure_small_O2 mem_small mem_small_O2 \
        run_medium run_medium_O2 measure_medium measure_medium_O2 mem_medium mem_medium_O2 \
        run_large run_large_O2 measure_large measure_large_O2 mem_large mem_large_O2 \
        measure_all measure_all_O2 clean