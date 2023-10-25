#!/bin/bash

# Detect os.
os_is_supported() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "FOUND"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    echo "NOTFOUND"
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    echo "NOTFOUND"
  elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    echo "NOTFOUND"
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "NOTFOUND"
  else
    echo "NOTFOUND"
  fi
}

assert_os_is_supported() {
  if [[ "$(os_is_supported)" != "FOUND" ]]; then
    red_msg "Error, os:$OSTYPE is not (yet) supported, please help build support." "true"
    exit 5
  fi
}

install_prerequisites() {
  local document_type="$1"
  assert_os_is_supported

  ensure_apt_pkg "texlive-xetex"

  ensure_apt_pkg "texlive-lang-european"

  # Custom:
  ensure_apt_pkg "texlive-science"

  # Allow converting .dia files to .eps files.
  ensure_apt_pkg "dia"

  if [[ "$document_type" == "TUDelft_thesis" ]]; then
    # Install the roboto font used by the TU Delft style files.
    ensure_apt_pkg "fonts-roboto"
    ensure_apt_pkg "texlive-fonts-extra"
  fi

  if [[ "$REL_PATH_CONTAINING_MAIN_TEX" == "2023-06-08-triodos_cv" ]]; then
    ensure_apt_pkg "texlive-fonts-extra"
  fi
}

assert_initial_path() {
  ## Ensure the script is executed from the root directory.
  echo "PWD=$PWD"
  echo "REL_MAIN_TEX_FILEPATH=$REL_MAIN_TEX_FILEPATH"

  if [ "$(is_root_dir "$PWD/$REL_MAIN_TEX_FILEPATH")" != "FOUND" ]; then
    echo "You are calling this script from the wrong directory."
    echo "Expected path towards main.tex is:"
    echo "$PWD/$REL_MAIN_TEX_FILEPATH"
    exit 21
  fi
}

prepare_output_dir() {
  ## Create clean output directories
  # Clean up build artifacts prior to compilation.
  local abs_output_dir="$PWD/$REL_PATH_CONTAINING_MAIN_TEX/$OUTPUT_DIR/"
  if [[ "$abs_output_dir" != "//" ]]; then
    if [ -d "$abs_output_dir" ]; then
      rm -r "$abs_output_dir"
    fi
  fi

  # Create output directory
  mkdir -p "$OUTPUT_PATH"
  assert_dir_exists "$OUTPUT_PATH"

  # Create relative dir from root to report.tex inside output dir
  # (for stylefile (for bibliograpy)).
  mkdir -p "$OUTPUT_PATH/$REL_PATH_CONTAINING_MAIN_TEX"
  assert_dir_exists "$OUTPUT_PATH/$REL_PATH_CONTAINING_MAIN_TEX"

  # Copy zotero.bib file into output directory
  cp zotero.bib "$OUTPUT_PATH/zotero.bib"
  assert_file_exists "$OUTPUT_PATH/zotero.bib"

  # Copy the stylefiles to the root directory.
  copy_stylefiles_to_target_dir "$OUTPUT_PATH/"

}
