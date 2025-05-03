#!/bin/bash

# Define number of times to execute each program
NTIMES=10

# Define the number of seconds to wait for the CPU to cooldown
COOLDOWN_SECONDS=30

# Set the root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Paths
BASE_DIR="$ROOT_DIR/Languages/Haskell/Fibonacci"
RAPL_DIR="$ROOT_DIR/RAPL"
UTILS_DIR="$ROOT_DIR/Utils"

# Define power limit values
# POWER_LIMITS=(-1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
POWER_LIMITS=(3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)

# Output file name
OUTPUT_FILE="$BASE_DIR/powercap_measure.csv"

# Compile sensors for temperature
cd "$RAPL_DIR" || { echo "RAPL dir missing"; exit 1; }
gcc -shared -o sensors.so sensors.c
cd - >/dev/null

# Update temperature thresholds
cd "$UTILS_DIR" || { echo "Utils dir missing"; exit 1; }
python3 temperatureUpdate.py "$COOLDOWN_SECONDS"
cd - >/dev/null

# Init output file
echo "Language,Program,PowerLimit,Package,Core,GPU,DRAM,Time,Temperature,Memory" > "$OUTPUT_FILE"

# Run tests if Makefile exists
if [ -f "$BASE_DIR/Makefile" ]; then
    cd "$BASE_DIR" || exit 1
    make compile  # Compile once before looping

    for limit in "${POWER_LIMITS[@]}"; do
        echo "Running with Power Limit: $limit"

        # Update power cap
        cd "$UTILS_DIR" || exit 1
        python3 raplCapUpdate.py "$limit" "$RAPL_DIR/main.c"
        cd - >/dev/null

        # Rebuild RAPL
        cd "$RAPL_DIR" || exit 1
        rm -f sensors.so
        make
        cd - >/dev/null

        # Run the measurement
        make measure GHC=ghc

        # Append results
        if [ -f measurements.csv ]; then
            tail -n +2 measurements.csv >> "$OUTPUT_FILE"
        else
            echo "Warning: No measurements for limit $limit"
        fi
    done

    make clean
    cd "$ROOT_DIR" || exit 1
else
    echo "Makefile not found in $BASE_DIR"
fi

# Final cleanup
cd "$RAPL_DIR" && make clean
cd "$ROOT_DIR" || exit 1

# Optional: reboot
# sudo reboot
