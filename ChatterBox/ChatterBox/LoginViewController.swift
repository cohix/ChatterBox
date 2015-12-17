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
    
    var network: CBInitialNetworkManager!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loginerr.hidden = true
        self.network = CBInitialNetworkManager()
        
        CBNetworkManager.sharedInstance().viewControllerDelegate = self

        
    }
    
    @IBAction func login(sender: UIButton) {
        CBNetworkManager.sharedInstance().login(self.username.text!, passwd: self.password.text!)
        print("happening")
       // self.presentViewController(ViewController(), animated: true, completion: nil)
    }
    
    func LoginFailed()
    {
        dispatch_async(dispatch_get_main_queue(), {()
            in
            self.loginerr.hidden=false
        })
        
    }
    
    func homeFromLogin()
    {
        dispatch_async(dispatch_get_main_queue(), {()
            in
            self.performSegueWithIdentifier("login", sender: self)
            self.loginerr.hidden=true
        })
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}