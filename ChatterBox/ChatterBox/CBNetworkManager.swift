//
//  CBNetworkManager.swift
//  ChatterBox
//
//  Created by Savanna on 11/23/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import AVFoundation
import Socket_IO_Client_Swift
import CocoaAsyncSocket

class CBNetworkManager : NSObject{
    
    var messageSocket: SocketIOClient!
    var streamingSocket: GCDAsyncSocket!
    
    override init(){
        super.init()
        self.setup()
        self.addHandlers()
        self.messageSocket.connect()
    }
    
    func setup(){
        self.messageSocket = SocketIOClient(socketURL: "localhost:8900")
    }
    
    func addHandlers(){
        self.messageSocket.onAny {
            print("got event: \($0.event) with items \($0.items)")
        }
        self.messageSocket.on("&roomupdate") {[weak self] data, ack in
            
            return
        }
    }
    
    func createUser(user: User){
      self.messageSocket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
    }
    
    func login(user : User){
        self.messageSocket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
    }
    
    // not sure how we're approaching this. should we have the chat room classes? seems like kyle would access them from the db but maybe I'm wrong? do we have direct access to the db too?
    func joinRoom(){
        self.messageSocket.emit("&joinroom;<" + ">&endm;")
    }
    
    func privateCall(user: User){
        self.messageSocket.emit("&private;<" + user.username + ">&endm;")
    }
}

