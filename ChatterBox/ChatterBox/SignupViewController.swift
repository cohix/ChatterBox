//
//  SignupViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/8/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation

class SignupViewController: UIViewController
{
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passerr: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var signuperr: UILabel!
    @IBOutlet weak var signuperror2: UILabel!
    
    //var network: CBNetworkManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.passerr.hidden = true
        self.signuperr.hidden = true
        self.signuperror2.hidden = true
        
        CBNetworkManager.sharedInstance().viewControllerDelegate = self
    }
    
    @IBAction func signup(sender: UIButton) {
        //if(self.password = "" && self.password2!="")
        if(self.password.text == self.password2.text){
            self.passerr.hidden = true
            CBNetworkManager.sharedInstance().signup(self.username.text!, passwd: self.password.text!)
        }
        else{
            self.passerr.hidden = false
        }
    }
    
    /*override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool{
        if self.password.text?.characters.count > 4 {
            if self.password.text == self.password2.text {
                return true
            }
        }
        return false
    }*/
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signupFailed()
    {
        self.signuperr.hidden=false
    }
    
    func homeFromSignup()
    {
        dispatch_async(dispatch_get_main_queue(), {()
        in
            self.performSegueWithIdentifier("signup", sender: self)
            self.signuperr.hidden=true
        })
    }
}
