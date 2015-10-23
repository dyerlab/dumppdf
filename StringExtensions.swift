//
//  StringExtensions.swift
//  dumppdf
//
//  Created by Rodney Dyer on 10/16/15.
//  Copyright © 2015 Rodney Dyer. All rights reserved.
//

import Foundation

extension String {
    
    var length : Int {
        get {
            return self.characters.count
        }
    }
    
    func contains( target: String ) -> Bool {
        return (self.rangeOfString(target) != nil) ? true : false
    }
    
    func indexOf( target: String ) -> Int {
        let range = self.rangeOfString(target)
        if let range = range {
            return  self.startIndex.distanceTo(range.startIndex)
        }
        else {
            return -1
        }
    }
    
    func substringBetween( fromString: String, toString: String ) -> String {
        let startIdx = (fromString.length == 0 ) ? self.startIndex : self.startIndex.advancedBy(self.indexOf(fromString)).advancedBy(fromString.length)
        let endIdx = (toString.length == 0 ) ? self.endIndex : self.startIndex.advancedBy(self.indexOf(toString))
        
        
        let range = Range( start: startIdx, end: endIdx )
        return self.substringWithRange( range )
    }
}