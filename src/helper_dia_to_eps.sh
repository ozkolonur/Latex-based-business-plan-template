#!/usr/bin/env bash

# This function lists all .eps files in the specified directory and its subdirectories,
# and converts them to .pdf files using epstopdf.
# Usage: eps_to_pdf_converter /path/to/eps/files
convert_dia_files_to_eps() {

  # Check if at least one argument (directory path) is provided.
  if [ $# -lt 1 ]; then
    echo "Usage: eps_to_pdf_converter /path/to/eps/files"
    return
  fi

  # Get the directory path as the first argument
  local directory="$1"

  # Check if the directory exists
  if [ ! -d "$directory" ]; then
    echo "Error: The specified directory does not exist."
    return
  fi

  # Find all .dia files in the specified directory and its subdirectories
  some_dia_files=$(find "$directory" -type f -name "*.dia")
  for dia_file in $some_dia_files; do

    # Check if the file is a valid .eps file
    if [[ "$dia_file" == *.dia ]]; then

      # Get the absolute path that contains the .dia file.
      local directory_path
      directory_path=$(dirname "$dia_file")
      # Get the filename with extension.
      local filename
      filename=$(basename -- "$dia_file")
      # Get the filename without extension
      local filename_no_ext
      filename_no_ext="${filename%.*}"

      # Convert the .dia file to .eps using apt package dia.
      dia --export="$directory_path/$filename_no_ext.eps" --filter=eps "$dia_file"
    fi
  done
}
