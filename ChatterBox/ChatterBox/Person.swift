//
//  Person.swift
//  ChatterBox
//
//  Created by Savanna on 12/17/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation

class Person{
    
    var username: String!
    var ip: String!
    
    init(username: String, ip: String){
        self.username = username
        self.ip = ip
    }
    
    func getName() -> String{
        return self.username
    }
    func getIp() -> String{
        return self.ip
    }
}
