//
//  Article.swift
//  dumppdf
//
//  Created by Rodney Dyer on 10/16/15.
//  Copyright © 2015 Rodney Dyer. All rights reserved.
//

import Foundation
import Quartz
import Cocoa



class Article : PDFDocument {
    
    // Override the super string() function to catch hyphenation
    override func string() -> String! {
        var raw_text = super.string()!
        let replacements = [ "- ":"", "-\n ":"", "-\r":"","-\r\n":"", "Fig. ":"Fig " ]
        for (old,new) in replacements {
            raw_text = raw_text.stringByReplacingOccurrencesOfString(old, withString: new)
        }
        return raw_text
    }
    
    

    

    
    // Pull string between keywords
    func stringSection( fromText: String, toText: String ) -> String {
        return self.string().substringBetween(fromText, toString: toText)
    }
    
    
    
    func tokenizeText( raw_text: String ) -> String {

        let path = NSBundle.mainBundle().pathForResource("stopwords", ofType:"plist")
        let stopwords = NSArray(contentsOfFile: path!)!
        let linguisticTags = NSArray(array: [ NSLinguisticTagNoun, NSLinguisticTagVerb, NSLinguisticTagAdverb, NSLinguisticTagAdjective, NSLinguisticTagPronoun, NSLinguisticTagParticle, NSLinguisticTagPreposition, NSLinguisticTagClassifier, NSLinguisticTagIdiom ])
        let taggerOptions: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames, .OmitOther]
        let linguisticSchemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
        let taggerOrthography = NSOrthography( dominantScript: "Latn", languageMap: ["Latn":["en"]])
        
        
        
        var return_text: [String] = []
        
        if raw_text.length > 0 {
            let text = raw_text as NSString
            let tagger = NSLinguisticTagger(tagSchemes: linguisticSchemes, options: Int(taggerOptions.rawValue))
            tagger.string = raw_text
            tagger.setOrthography( taggerOrthography, range: NSMakeRange(0,raw_text.length) )
            
            var currentSentence = tagger.sentenceRangeForRange( NSMakeRange(0,1) )
            if currentSentence.length < 1 {
                currentSentence.location = NSNotFound
            }
            var sentenceCounter = 0
            
            
            while( currentSentence.location != NSNotFound ) {
                var tokenPos: Int
                tokenPos = 0
    
                tagger.enumerateTagsInRange(    currentSentence,
                                                scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass,
                                                options: taggerOptions,
                                                usingBlock: { (tag: String, tokenRange: NSRange, sentenceRange: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let token = text.substringWithRange(tokenRange)
                    if token != "" {
                        var lemma = tagger.tagAtIndex(tokenRange.location, scheme: NSLinguisticTagSchemeLemma, tokenRange: nil, sentenceRange: nil)
                        if lemma == nil {
                            lemma = token
                        }
                        
                        
                        // only take some tags
                        if linguisticTags.containsObject(tag) {
                                var trimmedtag:NSString = tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.controlCharacterSet())
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.decomposableCharacterSet())
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.illegalCharacterSet())
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.nonBaseCharacterSet() )
                                trimmedtag = trimmedtag.stringByTrimmingCharactersInSet(NSCharacterSet.symbolCharacterSet())
                                if !stopwords.containsObject(lemma!) {
                                    return_text.append( lemma! )
                                }
                        }
                        tokenPos += 1
                    }
                })
                
                
                
                sentenceCounter += 1
                if currentSentence.location + currentSentence.length == text.length {
                    currentSentence.location = NSNotFound
                }
                else {
                    let nextSentence = NSMakeRange(currentSentence.location + currentSentence.length + 1, 1)
                    if nextSentence.length > 0 {
                        currentSentence = tagger.sentenceRangeForRange(nextSentence)
                    }
                    else {
                        currentSentence.location = NSNotFound
                    }
                }
            }
        }
        
        return return_text.joinWithSeparator(" ")
    }
    
    
    
    
}