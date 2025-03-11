#!/bin/bash

# Check if the folder path is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./import_all_ggufs.sh folder_path"
    exit 1
fi

# Resolve the folder path
GGUF_FOLDER="$1"

# Check if the folder exists
if [ ! -d "$GGUF_FOLDER" ]; then
    echo "Error: Folder not found - $GGUF_FOLDER"
    exit 1
fi

# Initialize counters
success_count=0
failure_count=0

# Loop through all GGUF files in the folder
cd "$GGUF_FOLDER" || {
    echo "Error: Could not navigate to folder - $GGUF_FOLDER"
    exit 1
}

for GGUF_FILE in *.gguf; do
    if [ ! -f "$GGUF_FILE" ]; then
        echo "No GGUF files found in $GGUF_FOLDER"
        break
    fi

    GGUF_NAME="$(basename "$GGUF_FILE")"
    MODEL_NAME="${GGUF_NAME%.gguf}"

    # Create a .model file with the FROM command
    echo "FROM $GGUF_NAME" > "$MODEL_NAME.model"
	echo # set the temperature to 1 [higher is more creative, lower is more coherent]
	echo #PARAMETER temperature 1 >> "$MODEL_NAME.model"
	echo # set the system message >> "$MODEL_NAME.model"
	echo #SYSTEM """ >> "$MODEL_NAME.model"
	echo #You are Mario from Super Mario Bros. Answer as Mario, the assistant, only. >> "$MODEL_NAME.model"
	echo #""" >> "$MODEL_NAME.model"

    # Run the Ollama create command
    echo "Importing $GGUF_NAME as model $MODEL_NAME"
    if ollama create "$MODEL_NAME" -f "$MODEL_NAME.model"; then
        echo "Successfully imported $GGUF_NAME"
        ((success_count++))
    else
        echo "Failed to import $GGUF_NAME"
        ((failure_count++))
    fi
done

# Print summary
echo "================================="
echo "Total GGUF files processed: $success_count success, $failure_count failure"
echo "================================="
