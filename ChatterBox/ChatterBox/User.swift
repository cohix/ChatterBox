//
//  User.swift
//  ChatterBox
//
//  Created by Savanna on 11/11/15.
//  Copyright (c) 2015 3203group. All rights reserved.
//

import Foundation


class User{
    
    var username: String
    var password: String
    
    init(){
        self.username = "Unknown"
        self.password = "Person"
    }
    
    init(uname: String, pword:String){
        self.username = uname
        self.password = pword
    }
    func getName() -> String{
        return self.username
    }
    func getPassword() -> String{
        return self.password
    }
}