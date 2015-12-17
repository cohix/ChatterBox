//
//  CBInitialNetworkManager.swift
//  ChatterBox
//
//  Created by Savanna on 12/17/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import SwiftyJSON
import Foundation
import AVFoundation
import Socket_IO_Client_Swift
import CocoaAsyncSocket

class CBInitialNetworkManager : NSObject , GCDAsyncSocketDelegate
{
    var initialConnectionSocket : GCDAsyncSocket!
    var myport : JSON!

    var finalnetwork: CBNetworkManager!
    override init(){
        super.init()
        self.initializeSocket()
        
    }
    func initializeSocket(){
        self.initialConnectionSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        do {
            try self.initialConnectionSocket.connectToHost("159.203.26.158", onPort: UInt16(5000))
        }
        catch
        {
            print("Error 7")
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int)
    {
        print("Reading data")
        let data2 = NSMutableData(data: data)
        data2.length = data2.length - 6
        
        let json = JSON(data: data2)
        print(json["port"].intValue)
        self.finalnetwork = CBNetworkManager()
        CBNetworkManager.sharedInstance().initializeSocket(json["port"].intValue)
    }
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
    {
        print("Streaming manager disconnected a socket")
        print(err.localizedDescription)
        
    }
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        print("Connected to \(host) on \(port)")
        sock.readDataWithTimeout(-1, buffer: nil, bufferOffset: 0, tag: 0)
    }

}