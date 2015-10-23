# dumppdf
Command line program to turn pdf documents into sanitized, lemmized, info packets.  

It works as follows:

```bash
iMac:~ rodney$ dumppdf
A simple command line program for parsing PDF files into textual components.
Usage: dumppdf -s Start -e End -l file

 where:
   - file is the path to the PDF file you want to parse.
   - StartTerm is the phrase you want to start targetted slice from (optional)
   - EndTerm the phrase where you want to stop the tragetted slice (optional)
   - l is a flag for lem, it will strip stopwords and lem text (optional)
```

If you do not provide a value for `StartTerm` or `EndTerm`, the entire text of the article is dumped to standard out.  If you do, it will only provide the internal slice of text between those two terms (the terms are not included in the output).

An example of the full 

```bash
-s "Abstract: " -e Keywords -l -w PNAS_Sus_001.pdf
```
