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

class CBNetworkManager : NSObject{
    
    var socket: SocketIOClient!
    
    override init(){
        super.init()
        self.setup()
        self.addHandlers()
        self.socket.connect()
    }
    
    func setup(){
        self.socket = SocketIOClient(socketURL: "localhost:8900")
    }
    
    func addHandlers(){
        self.socket.onAny {
            print("got event: \($0.event) with items \($0.items)")
        }
        self.socket.on("&roomupdate") {[weak self] data, ack in
            
            return
        }
    }
    
    func createUser(user: User){
      self.socket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
    }
    
    func login(user : User){
        self.socket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
    }
    
    // not sure how we're approaching this. should we have the chat room classes? seems like kyle would access them from the db but maybe I'm wrong? do we have direct access to the db too?
    func joinRoom(){
        self.socket.emit("&joinroom;<" + ">&endm;")
    }
    
    func privateCall(user: User){
        self.socket.emit("&private;<" + user.username + ">&endm;")
    }
}

