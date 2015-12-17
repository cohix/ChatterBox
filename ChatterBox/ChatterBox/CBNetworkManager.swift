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
    var messageSocket: GCDAsyncSocket!
    static let singleton: CBNetworkManager = CBNetworkManager()
    let end = "&endm;".dataUsingEncoding(NSUTF8StringEncoding)
    var initialConnectionSocket : GCDAsyncSocket!
    var myport : Int!
    var user: User!
    var signinsuccess: Int!
    
    var viewControllerDelegate: UIViewController!
    
    override init(){
        super.init()
        
    }
    
    static func sharedInstance() -> CBNetworkManager
    {
        return singleton
    }
    
    func initializeSocket(port: Int){
        self.myport = port
        self.messageSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        do {
            try self.messageSocket.connectToHost("159.203.26.158", onPort: UInt16(myport))
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
        
        
        print(NSString(data: data2, encoding: NSUTF8StringEncoding))
        
        let json = JSON(data: data2)
        

        if((json["signup"].stringValue) == "failure"){
            self.user = nil
            if(self.viewControllerDelegate != nil && self.viewControllerDelegate.respondsToSelector(Selector("signupFailed")))
            {
                self.viewControllerDelegate.performSelector(Selector("signupFailed"))
            }
        }
        if((json["signup"].stringValue) == "success"){
            if(self.viewControllerDelegate != nil && self.viewControllerDelegate.respondsToSelector(Selector("homeFromSignup")))
            {
                self.viewControllerDelegate.performSelector(Selector("homeFromSignup"))
            }
        }
        if((json["login"].stringValue) == "failure"){
            if(self.viewControllerDelegate != nil && self.viewControllerDelegate.respondsToSelector(Selector("loginFailed")))
            {
                self.viewControllerDelegate.performSelector(Selector("loginFailed"))
            }
        }
        
        if((json["login"].stringValue) == "success"){
            if(self.viewControllerDelegate != nil && self.viewControllerDelegate.respondsToSelector(Selector("homeFromLogin")))
            {
                self.viewControllerDelegate.performSelector(Selector("homeFromLogin"))
            }
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        print("Connected to \(host) on \(port)")
        sock.readDataWithTimeout(-1, tag: 0)
    }
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
    {
        print("Streaming manager disconnected a socket")
        //print(err.localizedDescription)
        
    }
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        sock.readDataToData(self.end!, withTimeout: -1, tag: 0)
    }
    func getAvailableUsers(){
        let jsonString = "{\"command\": \"getpeople\"}"
        print(jsonString)
        
        let temp = NSMutableData()
        
        let jsonData: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        print(jsonData)
        
        temp.appendData(jsonData)
        temp.appendData(self.end!)
        
        self.messageSocket.writeData(temp, withTimeout: -1, tag: 0)
        
    }
    func signup(name: String, passwd: String){
        let jsonString = "{\"command\": \"signup\", \"name\": \"\(name)\", \"password\": \"\(passwd)\"}"
        print(jsonString)
        
        let temp = NSMutableData()
        
        let jsonData: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        print(jsonData)
        
        temp.appendData(jsonData)
        temp.appendData(self.end!)
        
        self.messageSocket.writeData(temp, withTimeout: -1, tag: 0)
        
        user = User(uname: name,pword: passwd)
    }
    func login(name: String, passwd: String){
        let jsonString = "{\"command\": \"login\", \"name\": \"\(name)\", \"password\": \"\(passwd)\"}"
        print(jsonString)
        
        let temp = NSMutableData()
        
        let jsonData: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        print(jsonData)
        
        temp.appendData(jsonData)
        temp.appendData(self.end!)
        
        self.messageSocket.writeData(temp, withTimeout: -1, tag: 0)
        
        self.user = User(uname: name,pword: passwd)
    }
    
    func getUserName()->String{
        if(user==nil){
            return ""
        }
        return user.getName()
    }
 
}

