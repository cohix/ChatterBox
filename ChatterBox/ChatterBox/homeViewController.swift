//
//  homeViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/8/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation


class homeViewController: UIViewController
{
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var call: UIButton!
    @IBOutlet weak var meshcall: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var back: UIButton!
    
    //var network: CBNetworkManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.greeting.text = "Hello " + NetworkAccessor.sharednetwork.network.getUserName() + ", please select an option bellow."
        self.call.backgroundColor = UIColor.clearColor()
        self.call.layer.cornerRadius = 5
        self.call.layer.borderWidth = 1
        self.call.layer.borderColor = UIColor.blackColor().CGColor
        
        self.meshcall.backgroundColor = UIColor.clearColor()
        self.meshcall.layer.cornerRadius = 5
        self.meshcall.layer.borderWidth = 1
        self.meshcall.layer.borderColor = UIColor.blackColor().CGColor
        
        
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        NetworkAccessor.sharednetwork.network.user = nil
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}