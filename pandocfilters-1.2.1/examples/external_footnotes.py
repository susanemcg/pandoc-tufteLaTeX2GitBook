#!/usr/bin/env python

"""
Pandoc filter to convert all markdown footnotes to superscript-ed 
reference-number links to an external file, provided by the meta tag "footnote_file" 
passed into the main pandoc command, e.g.

pandoc YourTexFile.tex -f latex -t markdown -o YourMarkdownFile.md -M footnote_file=footnotes/README.html
--filter external_footnotes.py

"""

from pandocfilters import toJSONFilter, RawInline, Note

footnote_count = 0

def external_footnotes(key, value, format, meta):
  if key == 'Note':
    global footnote_count
    footnote_count = footnote_count + 1
    return RawInline('html',"<sup>["+str(footnote_count)+"]("+meta['footnote_file']['c']+")</sup>")

if __name__ == "__main__":
  toJSONFilter(external_footnotes)
