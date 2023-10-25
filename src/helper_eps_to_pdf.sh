#!/usr/bin/env bash

# This function lists all .eps files in the specified directory and its subdirectories,
# and converts them to .pdf files using epstopdf.
# Usage: eps_to_pdf_converter /path/to/eps/files
convert_eps_files_to_pdf() {

  # Check if at least one argument (directory path) is provided.
  if [ $# -lt 1 ]; then
    echo "Usage: eps_to_pdf_converter /path/to/eps/files"
    return
  fi

  # Get the directory path as the first argument
  directory="$1"

  # Check if the directory exists
  if [ ! -d "$directory" ]; then
    echo "Error: The specified directory does not exist."
    return
  fi

  # Find all .eps files in the specified directory and its subdirectories
  some_eps_files=$(find "$directory" -type f -name "*.eps")
  for eps_file in $some_eps_files; do
    if [[ "$eps_file" == *.eps ]]; then

      # Get the absolute path that contains the .eps file.
      local directory_path
      directory_path=$(dirname "$eps_file")
      # Get the filename with extension.
      local filename
      filename=$(basename -- "$eps_file")
      # Get the filename without extension
      local filename_no_ext
      filename_no_ext="${filename%.*}"

      # Convert the .eps file to .pdf using epstopdf and append the suffix.
      epstopdf "$eps_file" --outfile="$directory_path/$filename_no_ext-eps-converted-to.pdf"
    fi
  done
}
