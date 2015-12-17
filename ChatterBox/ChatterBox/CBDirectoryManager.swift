//
//  CBDirectoryManager.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-12-16.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation

class CBDirectoryManager: NSObject
{
    static func micWriteURL() -> NSURL?
    {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("chatterbox.m4a")
        return soundURL
    }
    
    static func randomWriteURL() -> NSURL?
    {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(CBDirectoryManager.randomFilename())
        return soundURL
    }
    
    static func randomFilename() -> String
    {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var filename: String = ""
        
        for _ in 0..<16
        {
            let random = self.randomNumber(0..<26)
            filename = "\(filename)\(letters[random])"
        }
        
        filename = "\(filename).m4a"
        
        return filename
    }
    
    static func randomNumber(range: Range<Int>) -> Int
    {
        let min = range.startIndex
        let max = range.endIndex
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
}