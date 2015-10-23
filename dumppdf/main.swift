//
//  main.swift
//  dumppdf
//
//  Created by Rodney Dyer on 10/16/15.
//  Copyright © 2015 Rodney Dyer. All rights reserved.
//

import Foundation

let argv = Process.arguments

// general usage
func usage() -> String {
    let ret = "A simple command line program for parsing PDF files into textual components.\nUsage: dumppdf -s Start -e End file\n\n where:\n   - file is the path to the PDF file you want to parse.\n   - StartTerm is the phrase you want to start targetted slice from (optional)\n   - EndTerm the phrase where you want to stop the tragetted slice (optional)\n\nIf you do not provide a value for StartTerm or EndTerm, the entire text of the article is dumped to standard out.  If you do, it will only provide the internal slice of text between those two terms (not included)."
    return ret
}

var textToDump: String = ""
var removeStopwords: Bool = false
var url: NSURL?
var doc: Article
let fromIdx = argv.indexOf("-s")
let toIdx = argv.indexOf("-e")
let lem = argv.indexOf("-l")
let stopwords: NSArray?

if argv.count > 1 {
    url = NSURL(fileURLWithPath: argv[argv.count-1] )
    doc = Article( URL: url )
    
    if fromIdx != nil && toIdx != nil {
        let fromTxt = argv[ fromIdx!+1 ]
        let toTxt = argv[ toIdx!+1 ]
        textToDump = doc.stringSection(fromTxt, toText: toTxt)
    }
    else {
        textToDump = doc.string()
    }

    
    // grab stopwords if requested.
   
    if lem != nil {
        textToDump = doc.tokenizeText(textToDump)
    }
    
    
}


else {
    print( usage() )
    exit( EX_USAGE )
}




print(textToDump)

