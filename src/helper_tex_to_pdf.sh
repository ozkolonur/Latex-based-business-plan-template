#!/usr/bin/env bash

compile_latex_into_pdf() {
  local ignore_bibtex="$1"
  local verbose_commands="$2"

  # Create some files needed for makeindex
  green_msg "Compiling:&$REL_MAIN_TEX_FILEPATH&into:&$OUTPUT_PATH" "true"
  if [[ "$verbose_commands" == "true" ]]; then
    pdflatex -output-directory="$PWD/$OUTPUT_PATH" "$REL_MAIN_TEX_FILEPATH"
  else
    pdflatex --interaction=batchmode -output-directory="$PWD/$OUTPUT_PATH" "$REL_MAIN_TEX_FILEPATH" >/dev/null 2>&1
  fi
  # shellcheck disable=SC2181
  if [[ "$?" != 0 ]]; then
    red_msg "Error, compilation error occurred in first pdflatex command." "true"
    exit 4
  fi

  # Go into output directory to compile the glossaries
  cd "$OUTPUT_PATH" || exit 6
  assert_current_directory_is_output_dir "$OUTPUT_PATH"

  # Compiling from root directory files
  #green_msg "Creating nomenclature" "true"
  #makeindex $REPORT_FILENAME.nlo -s nomencl.ist -o $REPORT_FILENAME.nls

  # Glossary
  #makeindex -s $REPORT_FILENAME.ist -t $REPORT_FILENAME.glg -o $REPORT_FILENAME.gls $REPORT_FILENAME.glo

  # List of acronyms
  #makeindex -s $REPORT_FILENAME.ist -t $REPORT_FILENAME.alg -o $REPORT_FILENAME.acr $REPORT_FILENAME.acn

  # Include glossary into $REPORT_FILENAME.
  #makeglossaries $REPORT_FILENAME

  # Compile bibliography.
  green_msg "Creating bibliography file." "true"
  if [[ "$verbose_commands" == "true" ]]; then
    bibtex "$REPORT_FILENAME"
  else
    local output_that_also_captures_error
    output_that_also_captures_error=$(bibtex "$REPORT_FILENAME" 2>&1)
  fi
  # Check for warnings and print them.
  if [[ "$(command_output_contains "arning" "$output_that_also_captures_error")" == "FOUND" ]]; then
    if [[ "$ignore_bibtex" != "true" ]]; then
      bibtex "$REPORT_FILENAME"
      yellow_msg "Warning, compilation warning occurred in bibtex command:" "true"
    fi
  fi
  # Check for errors and print them.
  if [[ "$(command_output_contains "rror" "$output_that_also_captures_error")" == "FOUND" ]]; then
    if [[ "$ignore_bibtex" != "true" ]]; then
      bibtex "$REPORT_FILENAME"
      red_msg "Error, compilation error occurred in bibtex command:" "true"
      exit 4
    fi
  fi

  # Go back up into root directory
  cd ../..
  assert_is_root_dir "$PWD/$REL_MAIN_TEX_FILEPATH"

  # Recompile $REPORT_FILENAME to include the bibliography.
  # TODO: make conditional, only compile if bibliography is included.
  green_msg "Recompiling to include bibliography." "true"
  if [[ "$verbose_commands" == "true" ]]; then
    pdflatex -output-directory="$PWD/$OUTPUT_PATH" "$REL_MAIN_TEX_FILEPATH"
  else
    pdflatex --interaction=batchmode -output-directory="$PWD/$OUTPUT_PATH" "$REL_MAIN_TEX_FILEPATH" >/dev/null 2>&1
  fi
  # shellcheck disable=SC2181
  if [[ "$?" != 0 ]]; then
    red_msg "Error, compilation error occurred in second pdflatex command (to include bibliography)." "true"
    exit 4
  fi

  # Recompile $REPORT_FILENAME to include acronyms, glossary and nomenclature (in TOC).
  # TODO: make conditional, only compile if acronyms, glossaries, or nomencalture exist.
  green_msg "Recompiling to include acronyms, glossary and nomenclature into TOC." "true"
  if [[ "$verbose_commands" == "true" ]]; then
    pdflatex -output-directory="$PWD/$OUTPUT_PATH" "$REL_MAIN_TEX_FILEPATH"
  else
    pdflatex --interaction=batchmode -output-directory="$PWD/$OUTPUT_PATH" "$REL_MAIN_TEX_FILEPATH" >/dev/null 2>&1
  fi
  # shellcheck disable=SC2181
  if [[ "$?" != 0 ]]; then
    red_msg "Error, compilation error occurred in third pdflatex command (to include acronyms etc. in TOC)." "true"
    exit 4
  fi

}
