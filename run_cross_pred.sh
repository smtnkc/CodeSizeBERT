#!/bin/bash

# Arrays of parameters
datasets=("code_cosmic" "code_microm")
targets_cosmic=("entry" "read" "write" "exit")
targets_microm=("interaction" "communication" "process")
models=("codebert")

# Total number of combinations for progress tracking
total=$((${#datasets[@]} * ${#targets_cosmic[@]} + ${#datasets[@]} * ${#targets_microm[@]} * ${#models[@]}))
current=0

# Function to show progress
show_progress() {
    local current=$1
    local total=$2
    local percentage=$((current * 100 / total))
    echo "Progress: $current/$total ($percentage%)"
}

# Main loop
for model in "${models[@]}"; do
    echo "============================================="
    echo "Starting experiments with model: $model"
    echo "============================================="
    
    for dataset in "${datasets[@]}"; do
        echo "---------------------------------------------"
        echo "Processing dataset: $dataset"
        echo "---------------------------------------------"
        
        if [ "$dataset" == "code_cosmic" ]; then
            targets=("${targets_cosmic[@]}")
        elif [ "$dataset" == "code_microm" ]; then
            targets=("${targets_microm[@]}")
        else
            echo "Unknown dataset: $dataset"
            continue
        fi

        for target in "${targets[@]}"; do
            ((current++))
            echo "Running combination $current of $total"
            echo "Model: $model"
            echo "Dataset: $dataset"
            echo "Target: $target"
            echo "---------------------------------------------"
            
            python cross_pred.py --dataset "$dataset" --target "$target" --model "$model"
            
            show_progress $current $total
            echo -e "\n"
        done
    done
done

echo "All combinations completed!" 