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
    var audioDatas: [NSMutableData]!
    
    var highestPort: UInt16 = 8080
    
    var writeQueue: NSOperationQueue!
    
    private static let singleton: CBStreamingManager = CBStreamingManager()
    
    override init()
    {
        self.sockets = [GCDAsyncSocket]()
        self.files = [NSURL]()
        self.audioDatas = [NSMutableData]()
        
        self.writeQueue = NSOperationQueue()
    }
    
    static func sharedInstance() -> CBStreamingManager
    {
        return self.singleton
    }
    
    func newConnection(ip: String, port: Int)
    {
        print("Attempting to connect to \(ip): \(port)")
        
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
        self.audioDatas.append(NSMutableData())
    }
    
    func acceptNewConnection() -> UInt16
    {
        self.highestPort++
        
        let newSock = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        do {
            try newSock.acceptOnPort(self.highestPort)
        }
        catch
        {
            print("Error 8")
        }
        
        self.sockets.append(newSock)
        self.files.append(CBDirectoryManager.randomWriteURL()!)
        self.audioDatas.append(NSMutableData())
        
        return self.highestPort
    }
    
    func addNewSocket(socket: GCDAsyncSocket)
    {
        print("Adding socket")
        
        socket.setDelegate(self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        self.sockets.append(socket)
        self.files.append(CBDirectoryManager.randomWriteURL()!)
        self.audioDatas.append(NSMutableData())
        
        socket.readDataToData(GCDAsyncSocket.CRData(), withTimeout: -1, tag: 0)
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        print("Connected to \(host) on \(port)")
        
        sock.readDataToData(GCDAsyncSocket.CRData(), withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
    {
        print("Streaming manager disconnected a socket")
        print(err.localizedDescription)
        guard let index = self.sockets.indexOf(sock) else {return}
        
        self.sockets.removeAtIndex(index)
        self.files.removeAtIndex(index)
        self.audioDatas.removeAtIndex(index)
    }
    
    func writeMicAudioToAllSockets()
    {
        print("Writing mic data")
        
        let message = NSMutableData()
        
        let audio: NSData = NSData(contentsOfURL: CBDirectoryManager.micWriteURL()!)!
        message.appendData( NSString(format: "%d", audio.length).dataUsingEncoding(NSUTF8StringEncoding)! )
        message.appendData(GCDAsyncSocket.CRData())
        
        for sock in self.sockets
        {
            sock.writeData(message , withTimeout: -1, tag: 0)
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int)
    {
        if(tag == 0)
        {
            let audio: NSData = NSData(contentsOfURL: CBDirectoryManager.micWriteURL()!)!
            
            sock.writeData(audio, withTimeout: -1, tag: 1)
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int)
    {
        print("Reading data")
        let index: Int = self.sockets.indexOf(sock)!
        
        if tag == 0
        {
            print("Tag 0")
            let strippedData: NSMutableData = NSMutableData(data: data)
            strippedData.length = strippedData.length - 1
            
            let fullString = NSString(data: strippedData, encoding: NSUTF8StringEncoding)!
            let length: UInt = UInt((Int(fullString as String)!))
            
            print(fullString)
            print(length)
            
            sock.readDataToLength(length, withTimeout: -1, tag: 1)
        }
        else if tag == 1
        {
            self.audioDatas[index].appendData(data)
            
            let writeOp = CBWriteOperation(data: self.audioDatas[index], url: self.files[index])
            self.writeQueue.addOperation(writeOp)
            
            self.audioDatas[index] = NSMutableData()
            sock.readDataToData(GCDAsyncSocket.CRData(), withTimeout: -1, tag: 0)
        }
    }
    
    func getWiFiAddress() -> String?
    {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let interface = ptr.memory
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface.ifa_addr.memory.sa_family
                if addrFamily == UInt8(AF_INET) {
                    
                    // Check interface name:
                    if let name = String.fromCString(interface.ifa_name) where name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var addr = interface.ifa_addr.memory
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                        address = String.fromCString(hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
}
