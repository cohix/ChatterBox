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
    
    //host user
    var user: User!
    
    override init(){
        super.init()
        self.setup()
        self.addHandlers()
        self.socket.connect()
    }
    
    func login(name: String, passwd: String)->Bool{
        user = User(uname: name,pword: passwd)
        if(!login(user)){
            return false
        }
        return true
    }
    
    func signup(name: String, passwd: String)->Bool{
        user = User(uname: name,pword: passwd)
        if(!createUser(user)){
            return false
        }
        return true
    }
    
    func setup(){
        self.socket = SocketIOClient(socketURL: "localhost:8900")
    }
    
    func getUserName()->String{
        if(user==nil){
            return ""
        }
        return user.getName()
    }
    
    func addHandlers(){
        self.socket.onAny {
            print("got event: \($0.event) with items \($0.items)")
        }
    }
    
    func createUser(user: User)->Bool{
      self.socket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
        return true
        
    }
    
    func login(user : User)->Bool{
        self.socket.emit("&create;<" + user.getName() + ">&endm;<" + user.getPassword() + ";>endm;")
          return true
    }
    
    // not sure how we're approaching this. should we have the chat room classes? seems like kyle would access them from the db but maybe I'm wrong? do we have direct access to the db too?
    func joinRoom(){
        self.socket.emit("&joinroom;<" + ">&endm;")
    }
    
    func privateCall(user: User){
        self.socket.emit("&private;<" + user.username + ">&endm;")
    }
}

