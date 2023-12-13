#!/bin/bash

# Read file into an array
mapfile -t lines < repo.txt
mkdir -p "/profiles"

# Iterate over the lines
for line in "${lines[@]}"; do
    echo "Processing: $line"
    start_time=$(date +%s)  # Capture start time

    # Skip empty lines
    if [ -z "$line" ]; then
        echo "Empty line, skipping..."
        continue
    fi

    # Clone repo into a temporary directory
    repo_name=$(basename "$line" .git)
    tmp_dir="/tmp/$repo_name"
    git clone "$line" "$tmp_dir" > /dev/null 2>&1

    # Copy into /exercise/assignment
    assignment_dir="/exercise/assignment"
    rm -rf "$assignment_dir"
    mkdir -p "$assignment_dir"
    cp -R "$tmp_dir/"* "$assignment_dir"

    # Run `/gradlew clean test` in /exercise
    (cd /exercise &&  ./gradlew clean test --profile) > /dev/null 2>&1

    end_time=$(date +%s)  # Capture end time
    duration=$((end_time - start_time))  # Calculate duration

    echo "Time taken for $line: ${duration} seconds"

    cp -R /exercise/build/reports/profile/*.html /profiles
done

echo "Script completed."
