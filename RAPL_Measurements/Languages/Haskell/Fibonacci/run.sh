#!/bin/bash

VERSIONS=(8.4.4 8.10.7 9.2.2 9.4.8)
TARGETS=("measure" "measure_O2")

for ghc_ver in "${VERSIONS[@]}"; do
    echo "======================="
    echo "Testing GHC $ghc_ver"
    echo "======================="

    # Get path to GHC binary
    GHC_PATH=$(ghcup whereis ghc "$ghc_ver")
    
    # Check if path exists and executable
    if [ ! -x "$GHC_PATH" ]; then
        echo "GHC version $ghc_ver not found or not executable."
        continue
    fi

    echo "Using GHC at: $GHC_PATH"
    export GHC="$GHC_PATH"

    for target in "${TARGETS[@]}"; do
        echo "Running target: $target with GHC $ghc_ver"
        
        # Clean, then compile/measure
        make clean
        make $target GHC="$GHC"

        # Move results if any
        if [ -f measurements.csv ]; then
            mkdir -p results/$ghc_ver
            mv measurements.csv results/$ghc_ver/${target}.csv
            echo "Saved measurements to results/$ghc_ver/${target}.csv"
        else
            echo "measurements.csv not found"
        fi

        echo
    done
done
