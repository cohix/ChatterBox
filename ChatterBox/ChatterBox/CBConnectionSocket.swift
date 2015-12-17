//
//  CBConnectionSocket.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-12-16.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class CBConnectionSocket: NSObject, GCDAsyncSocketDelegate
{
    var socket: GCDAsyncSocket!
    
    func start()
    {
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        do {
            try self.socket.acceptOnPort(8080)
        }
        catch
        {
            print("Error 7")
        }
        
        print("Awaiting connection")
    }
    
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Connection Socket accepted")
        
        CBStreamingManager.sharedInstance().addNewSocket(newSocket)
    }
}
