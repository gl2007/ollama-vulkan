#!/bin/bash

# Check if the GGUF file path is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./import_single_gguf.sh gguf_file_path"
    exit 1
fi

# Resolve the full path to the file
GGUF_FILE=$(realpath "$1" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Error: File not found - $1"
    exit 1
fi

# Extract the file name and directory
GGUF_FOLDER="$(dirname "$GGUF_FILE")"
GGUF_NAME="$(basename "$GGUF_FILE")"
MODEL_NAME="${GGUF_NAME%.gguf}"

# Change directory to the GGUF folder
cd "$GGUF_FOLDER" || {
    echo "Error: Could not navigate to folder - $GGUF_FOLDER"
    exit 1
}

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
    echo "================================="
    echo "Import completed successfully for $GGUF_NAME"
    echo "================================="
else
    echo "Failed to import $GGUF_NAME"
    exit 1
fi
