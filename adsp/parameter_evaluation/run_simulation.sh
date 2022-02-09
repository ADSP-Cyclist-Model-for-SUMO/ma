#! /usr/bin/env bash

SCENARIO_FOLDER="sim_scenarios"
SIM_DATA_FOLDER="sim_data"

SCENARIO_NAME_SUFFIXES=("default" "new_params")

run_simulation() {
    mkdir tmp_sim

    /sumo/bin/sumo -c "$SCENARIO_FOLDER"/"$SCENARIO_SUB_FOLDER"/"$SCENARIO_NAME".sumocfg \
        --fcd-output tmp_sim/fcd_out.xml --device.fcd.explicit vehDist --fcd-output.geo 

    python /sumo/tools/xml/xml2csv.py tmp_sim/fcd_out.xml

    mv tmp_sim/fcd_out.csv "$SIM_DATA_FOLDER"/"$SCENARIO_NAME".csv

    rm -rf tmp_sim
}

if [[ "$1" == "ALL" ]]; then
    cd "$SCENARIO_FOLDER"
    for SUB_FOLDER in */ ; do
        SCENARIO_SUB_FOLDER=${SUB_FOLDER%/}
        cd ..
        for SUFFIX in "${SCENARIO_NAME_SUFFIXES[@]}"; do
            SCENARIO_NAME="$SCENARIO_SUB_FOLDER"_"$SUFFIX"
            echo "Running scenario "$SCENARIO_NAME"..."
            run_simulation
        done
    done
else
    SCENARIO_SUB_FOLDER="$1"
    SCENARIO_NAME_SUFFIX="$2"
    SCENARIO_NAME="$SCENARIO_SUB_FOLDER"_"$SCENARIO_NAME_SUFFIX"
    echo "Running scenario "$SCENARIO_NAME"..."
    run_simulation
fi
