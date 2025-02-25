#!/bin/bash

source ./build-settings.sh

echo "Generating main LaTeX source"
tools/generate-main-tex.sh

echo "Building LaTeX document"
latexmk -output-directory="./build" -pdf ${MAIN}.tex
