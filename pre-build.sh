#!/bin/bash

source ./build-settings.sh

echo "Generating main LaTeX source"
tools/instantiate-cv-template.py

echo "Fetching bibliography from Zotero"
tools/get-zotero-bibtex.sh

echo "Sanitizing downloaded bib files"
for bibfile in bibliography/*.bib
do
    bibfile_raw=${bibfile%.bib}-raw.bib
    mv "$bibfile" "$bibfile_raw" 
    tools/sanitize-zotero-bib.py "$bibfile_raw" "$bibfile"
done

echo "Obtaining Google Scholar data"
python3 tools/scholarly-metrics.py --name "$FULLNAME" > /dev/null

echo "Obtaining GitHub contribution data"
datecmd=$(which gdate)
[ -x "$datecmd" ] || datecmd=$(which date)
first_year=$($datecmd --date="5 years ago" +%Y)
last_year=$($datecmd --date="1 year ago" +%Y)
python3 tools/github-commits.py  --first-year $first_year --last-year $last_year --username $GITHUB_USER --modern-cv
sleep 5
