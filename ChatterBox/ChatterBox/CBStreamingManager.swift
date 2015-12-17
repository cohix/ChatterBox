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
    
    var highestPort: UInt16 = 8080
    
    var writeQueue: NSOperationQueue!
    
    var audioData = NSMutableData()
    
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
        
        return self.highestPort
    }
    
    func addNewSocket(socket: GCDAsyncSocket)
    {
        print("Adding socket")
        
        socket.setDelegate(self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        self.sockets.append(socket)
        self.files.append(CBDirectoryManager.randomWriteURL()!)
        
        socket.readDataWithTimeout(-1, buffer: nil, bufferOffset: 0, tag: 0)
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        print("Connected to \(host) on \(port)")
        sock.readDataWithTimeout(-1, buffer: nil, bufferOffset: 0, tag: 0)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
    {
        print("Streaming manager disconnected a socket")
        print(err.localizedDescription)
        guard let index = self.sockets.indexOf(sock) else {return}
        
        let writeOp = CBWriteOperation(data: self.audioData, url: self.files[index])
        self.writeQueue.addOperation(writeOp)
        
        self.sockets.removeAtIndex(index)
        self.files.removeAtIndex(index)
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int)
    {
        print("Reading data")
        
        //guard let index = self.sockets.indexOf(sock) else {return}
        
        self.audioData.appendData(data)
        
        sock.readDataWithTimeout(-1, buffer: nil, bufferOffset: 0, tag: 0)
    }
    
    func writeMicAudioToAllSockets()
    {
        print("Writing mic data")
        
        let audio: NSData = NSData(contentsOfURL: CBDirectoryManager.micWriteURL()!)!
        
        for sock in self.sockets
        {
            sock.writeData(audio, withTimeout: -1, tag: 0)
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
