#!/bin/bash

source ./build-settings.sh

export OUTPUT_GSCHOLAR=99-scholarly-bibliometrics.tex
export OUTPUT_GITHUB=99-github-contributions.tex

echo "Generating main LaTeX source"
tools/instantiate-cv-template.py

echo "Fetching bibliography from Zotero"
tools/get-zotero-bibtex.sh

echo "Sanitizing downloaded bib files"
for bibfile in bibliography/*.bib
do
    bibfile_raw="${bibfile%.bib}-raw.bib"
    mv "$bibfile" "$bibfile_raw" 
    tools/sanitize-zotero-bib.py "$bibfile_raw" "$bibfile"
done

if [[ -n "${GSCHOLAR_PROFILE}" && ! -f "$OUTPUT_GSCHOLAR" ]]; then
    echo "Obtaining Google Scholar data for $GSCHOLAR_PROFILE"
    python3 tools/scholarly-metrics.py --profile "$GSCHOLAR_PROFILE" > /dev/null
fi

touch $OUTPUT_GSCHOLAR

if [[ -n "${GITHUB_USER}" && ! -f "$OUTPUT_GITHUB" ]]; then
    echo "Obtaining GitHub contribution data for $GITHUB_USER"
    datecmd=$(which gdate)
    [[ -x "$datecmd" ]] || datecmd=$(which date)
    first_year=$($datecmd --date="5 years ago" +%Y)
    last_year=$($datecmd --date="1 year ago" +%Y)
    python3 tools/github-commits.py  --first-year $first_year --last-year $last_year --username $GITHUB_USER --modern-cv
fi

touch $OUTPUT_GITHUB
