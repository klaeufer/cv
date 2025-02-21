#!/bin/bash

source ./build-settings.sh

latexmk -output-directory="./build" -pdf ${MAIN}.tex
