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
        username = "Unknown"
        password = "Person"
    }
    
    init(uname: String, pword:String){
        username = uname
        password = pword
    }
}