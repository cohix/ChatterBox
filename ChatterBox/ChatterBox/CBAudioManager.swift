//
//  CBAudioManager.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-12-16.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation

class CBAudioManager: NSObject
{
    private var playQueue: NSOperationQueue!
    private static let singleton: CBAudioManager = CBAudioManager()
    
    override init()
    {
        self.playQueue = NSOperationQueue()
    }
    
    static func sharedInstance() -> CBAudioManager
    {
        return singleton
    }

    func queuePlayOperation(operation: CBAudioPlayerOperation)
    {
        self.playQueue.addOperation(operation)
    }
}