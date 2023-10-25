#!/usr/bin/env bash

postprocess() {

  # Move pdf back into "$REL_PATH_CONTAINING_MAIN_TEX.
  mv "$OUTPUT_PATH/$REPORT_FILENAME.pdf" "$REL_PATH_CONTAINING_MAIN_TEX/$REPORT_FILENAME.pdf"

  # Clean up build artifacts.
  rm -r "$OUTPUT_PATH/$REPORT_FILENAME".*

  # Clean up style files.
  remove_stylefiles_from_target_dir "$OUTPUT_PATH/"
}
