//
//  LoginViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/8/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation


class LoginViewController: UIViewController
{
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginerr: UILabel!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var network: CBNetworkManager!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loginerr.hidden = true
        //initialize shared network from singleton class
        NetworkAccessor.sharednetwork.network = CBNetworkManager()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func login(sender: UIButton) {
        if(NetworkAccessor.sharednetwork.network.login(self.username.text!, passwd: self.password.text!)){
            self.loginerr.hidden=true
            performSegueWithIdentifier("login", sender: self)
        }else{
            self.loginerr.hidden = false
        }
        //print(ok)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}