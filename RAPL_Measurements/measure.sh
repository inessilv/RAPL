#!/bin/bash

# Define number of times to execute each program
NTIMES=10

# Define the number of seconds to wait for the CPU to cooldown
COOLDOWN_SECONDS=30

# Define power limit values
POWER_LIMITS=(-1)

# Compile sensors which will be used to calculate cool temperature
cd RAPL
gcc -shared -o sensors.so sensors.c
cd ..

# Update the temperature value
cd Utils/
python3 temperatureUpdate.py $COOLDOWN_SECONDS

# Update the number of times the program will run for each case
for language in "../Languages"/*; do
    for program in "$language"/*; do
        if [ -d "$program" ]; then
            makefile_path="$program/Makefile"
            if [ -f "$makefile_path" ]; then
                python3 ntimesUpdate.py "$NTIMES" "$makefile_path"
            else
                echo "Makefile not found: $makefile_path"
            fi
        fi
    done
done
cd ..

# Initialize measurements file
echo "Language,Program,PowerLimit,Package,Core,GPU,DRAM,Time,Temperature,Memory" > measurements.csv

# Loop over power limit values
for limit in "${POWER_LIMITS[@]}"
do
    cd Utils/
    python3 raplCapUpdate.py $limit ../RAPL/main.c
    cd ..
    
    # Make RAPL
    cd RAPL/
    rm sensors.so
    make
    cd ..

    # Iterate over programs
    for language in "Languages"/*; do
        for program in "$language"/*; do
            if [ -d "$program" ]; then
                makefile_path="$program/Makefile"
                if [ -f "$makefile_path" ]; then
                    cd $program
                    make compile
                    make measure 

                    # Append results to measurements.csv
                    file="measurements.csv"
                    tail -n +2 "$file" >> ../../../measurements.csv
                    make clean
                    cd ../../..
                else
                    echo "Makefile not found: $makefile_path"
                fi
            fi
        done
    done
done

# Clean up RAPL directory
cd RAPL/
make clean
cd ..

# Reboot system
# sudo reboot
