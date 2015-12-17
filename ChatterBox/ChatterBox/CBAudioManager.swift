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
    private var operations: [CBAudioPlayerOperation]!
    private static let singleton: CBAudioManager = CBAudioManager()
    
    override init()
    {
        self.playQueue = NSOperationQueue()
        self.operations = [CBAudioPlayerOperation]()
    }
    
    static func sharedInstance() -> CBAudioManager
    {
        return singleton
    }

    func queuePlayOperation(op: CBAudioPlayerOperation)
    {
        self.operations.append(op)
        self.playQueue.addOperation(op)
    }
}