//
//  CBNetworkManager.swift
//  ChatterBox
//
//  Created by Savanna on 11/23/15.
//  Copyright © 2015 3203group. All rights reserved.
//
import SwiftyJSON
import Foundation
import AVFoundation
import Socket_IO_Client_Swift
import CocoaAsyncSocket

class CBNetworkManager : NSObject , GCDAsyncSocketDelegate
{    
    var messageSocket: SocketIOClient!
    static let singleton: CBNetworkManager = CBNetworkManager()
    var initialConnectionSocket : GCDAsyncSocket!
    var myport : JSON!
    var user: User!
    
    override init(){
        super.init()
        self.initializeSocket()
        
    }
    
    static func sharedInstance() -> CBNetworkManager
    {
        return singleton
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
        self.myport = JSON(data: data2)
        print(self.myport["port"].intValue)
        self.setup()
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        print("Connected to \(host) on \(port)")
        sock.readDataWithTimeout(-1, buffer: nil, bufferOffset: 0, tag: 0)
    }
    func login(name: String, passwd: String)->Bool{
        // let dic = ["username": "sav"]
        //let jsonuser = JSON(dic)
        //print(jsonuser)
        user = User(uname: name,pword: passwd)
        if(!login(user)){
            return false
        }
        return true
    }
    
    func signup(name: String, passwd: String)->Bool{
        let jsonString = "{\"command\": \"signup\", \"name\": \"\(name)\", \"password\": \"\(passwd)\"}"
        print(jsonString)
        
        let jsonData: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        print(jsonData)
        
        let jsonObj = JSON(data: jsonData)
        print(jsonObj)
        
        print(self.messageSocket)
        self.messageSocket.emit("\(jsonString)&endm;")
        user = User(uname: name,pword: passwd)
       // if(!createUser(user)){
         //   return false
     //   }
        return true
    }
    
    func setup(){
        print("Connecting new socket")
        self.messageSocket = SocketIOClient(socketURL: "159.203.26.158:" + myport["port"].stringValue)
        self.addHandlers()
       // self.messageSocket.connect()
        self.messageSocket.connect(timeoutAfter: 10, withTimeoutHandler: noConnect())
    }
    func noConnect(){
        print("didn't connect")
    }
    func getUserName()->String{
        if(user==nil){
            return ""
        }
        return user.getName()
    }
    
    func addHandlers(){
        self.messageSocket.onAny {
            print("got event: \($0.event) with items \($0.items)")
        }
    }
    
    func createUser(user: User)->Bool{
      self.messageSocket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
        return true
        
    }
    
    func login(user : User)->Bool{
        self.messageSocket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
          return true
    }
    
    // not sure how we're approaching this. should we have the chat room classes? seems like kyle would access them from the db but maybe I'm wrong? do we have direct access to the db too?
    func joinRoom(){
        self.messageSocket.emit("&joinroom;<" + ">&endm;")
    }
    
    func privateCall(user: User){
        self.messageSocket.emit("&private;<" + user.username + ">&endm;")
    }
}

