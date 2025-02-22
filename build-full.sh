#!/bin/bash

source ./build-settings.sh

# Each of my BibTeX entries is kept in a separate file and assembled into one (for each type of publication).
# Makes it easier to keep up-to-date.
# Every entry in the .bib MUST have a year to sort properly. (We don't rigidly sort by other fields, month, day, since these don't always appear).

echo "Fetching bibliography from Zotero"
tools/get-zotero-bibtex.sh

echo "Obtaining Google Scholar data"
python3 tools/scholarly-metrics.py --name "$FULLNAME" > /dev/null

echo "Obtaining GitHub contribution data"
datecmd=$(which gdate)
[ -x "$datecmd" ] || datecmd=$(which date)
first_year=$($datecmd --date="5 years ago" +%Y)
last_year=$($datecmd --date="1 year ago" +%Y)
python3 tools/github-commits.py  --first-year $first_year --last-year $last_year --username $GITHUB_USER --modern-cv
sleep 5

echo "Building LaTeX document"
latexmk -output-directory="./build" -C -pdf ${MAIN}.tex
latexmk -output-directory="./build" -pdf ${MAIN}.tex

if [ -f build/${MAIN}.pdf ]; then
  if [ -d ../${DOMAIN} ]; then
     cat bibliography/*.bib > ../${DOMAIN}/_bibliography/papers.bib
     echo "Copied latest bibliography to website folder"
  fi 
fi
