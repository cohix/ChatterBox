//
//  NetworkAccessor.swift
//  ChatterBox
//
//  Created by Savanna on 12/8/15.
//  Copyright © 2015 3203group. All rights reserved.
//

//Singleton class to give all view controllers access to the same network manager.

class NetworkAccessor{
    var network: CBNetworkManager!
    static let sharednetwork = NetworkAccessor()
    
}
