//
//  CPWriteOperation.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-12-16.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation

class CBWriteOperation: NSOperation
{
    let data: NSData!
    let url: NSURL!
    
    init(data: NSData, url: NSURL)
    {
        self.data = data
        self.url = url
    }
    
    override func main()
    {
        data.writeToURL(self.url, atomically: true)
        let playOp = CBAudioPlayerOperation(url: self.url)
        CBAudioManager.sharedInstance().queuePlayOperation(playOp)
    }
}