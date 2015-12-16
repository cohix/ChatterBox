//
//  CBStreamingManager.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-12-16.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class CBStreamingManager: NSObject, GCDAsyncSocketDelegate
{
    var sockets: [GCDAsyncSocket]!
    var files: [NSURL]!
    
    var writeQueue: NSOperationQueue!
    
    private static let singleton: CBStreamingManager = CBStreamingManager()
    
    override init()
    {
        self.sockets = [GCDAsyncSocket]()
        self.files = [NSURL]()
        
        self.writeQueue = NSOperationQueue()
    }
    
    static func sharedInstance() -> CBStreamingManager
    {
        return self.singleton
    }
    
    func newConnection(ip: String, port: Int)
    {
        let newSock = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        do {
            try newSock.connectToHost(ip, onPort: UInt16(port))
        }
        catch
        {
            print("Error 7")
        }
        
        self.sockets.append(newSock)
        self.files.append(CBDirectoryManager.randomWriteURL()!)
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        print("Connected to \(host) on \(port)")
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
    {
        print("Disconnecting from socket")
        guard let index = self.sockets.indexOf(sock) else {return}

        self.sockets.removeAtIndex(index)
        self.files.removeAtIndex(index)
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int)
    {
        guard let index = self.sockets.indexOf(sock) else {return}
        
        let writeOp = CBWriteOperation(data: data, url: self.files[index])
        self.writeQueue.addOperation(writeOp)
        
        
    }
}
