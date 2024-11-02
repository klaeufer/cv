#!/usr/bin/env python

# adds tag bibtex_show = 1 to each entry
# https://chatgpt.com/share/67262f17-f954-8002-903e-fb7601bb48fe

import glob
import re

# Folder containing your .bib files
bib_folder = "*/*.bib"

# Regular expression to find the start of each BibTeX entry
entry_start_regex = re.compile(r"(@[a-zA-Z]+{[^,]+,)")
tag_to_add = "bibtex_show=1"

# Function to process a single entry and add the tag if missing
def process_entry(entry):
    # Check if the tag is already present
    if tag_to_add in entry:
        return entry
    
    # Insert the tag before the last closing brace, checking for trailing comma
    brace_count = 0
    for i in range(len(entry) - 1, -1, -1):
        if entry[i] == '}':
            brace_count += 1
        elif entry[i] == '{':
            brace_count -= 1
        # Find the position of the last top-level closing brace
        if brace_count == 1:
            # Look for a comma on or before the last line before the closing brace
            preceding_text = entry[:i].rstrip()
            if preceding_text.endswith(","):
                return preceding_text + f" {tag_to_add}" + entry[i:]
            else:
                return preceding_text + f", {tag_to_add}" + entry[i:]
    
    # Return the original entry if no match (should not happen with valid BibTeX)
    return entry

# Loop through each .bib file in the folder
for file_path in glob.glob(bib_folder):
    with open(file_path, "r") as file:
        content = file.read()
    
    # Split content based on entry start
    entries = entry_start_regex.split(content)
    modified_content = entries[0]  # First part (anything before the first entry)
    
    # Process each entry
    for i in range(1, len(entries), 2):
        entry_start = entries[i]
        entry_content = entries[i + 1]
        entry = entry_start + entry_content
        modified_content += process_entry(entry) + "\n\n"
    
    # Write back the modified content to the file
    with open(file_path, "w") as file:
        file.write(modified_content)

print("Tag 'bibtex_show=1' has been added to all entries without adding extra commas.")
