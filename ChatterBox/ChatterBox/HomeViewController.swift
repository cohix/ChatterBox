//
//  homeViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/8/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation


class HomeViewController: UIViewController
{
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var call: UIButton!
    @IBOutlet weak var meshcall: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var back: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.greeting.text = "Hello " + CBStreamingManager.sharedInstance().getWiFiAddress()! + ", please select an option bellow."
        self.call.backgroundColor = UIColor.clearColor()
        self.call.layer.cornerRadius = 5
        self.call.layer.borderWidth = 1
        self.call.layer.borderColor = UIColor.blackColor().CGColor
        self.call.addTarget(self, action: Selector("callSomeone"), forControlEvents: .TouchUpInside)
        
        self.meshcall.backgroundColor = UIColor.clearColor()
        self.meshcall.layer.cornerRadius = 5
        self.meshcall.layer.borderWidth = 1
        self.meshcall.layer.borderColor = UIColor.blackColor().CGColor
        
        CBNetworkManager.sharedInstance().viewControllerDelegate = nil
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        CBNetworkManager.sharedInstance().user = nil
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callSomeone()
    {
        print("Got here")
        dispatch_async(dispatch_get_main_queue(), {()
        in
            self.presentViewController(ViewController(), animated: true, completion: nil)
        })
    }
    
}