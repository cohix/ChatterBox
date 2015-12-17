//
//  SimpleCallViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/9/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleCallViewController: UIViewController
{
    var micHandler: CBMicrophoneHandler!
    var audioPlayer: CBAudioPlayerOperation!
    
    @IBOutlet weak var ipaddr: UITextField!
    var people: [Person] = [Person]()
    var connectionSocket: CBConnectionSocket!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var refresh: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var call: UIButton!
    @IBOutlet weak var record: UIButton!
    var users: [User] = [User]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     //   CBNetworkManager.sharedInstance().getAvailableUsers()
        self.greeting.text = "Hello " + CBNetworkManager.sharedInstance().getUserName() + "."
        self.micHandler = CBMicrophoneHandler()

        CBNetworkManager.sharedInstance().viewControllerDelegate = self
        self.connectionSocket = CBConnectionSocket()
        self.connectionSocket.start()
        
        self.record.addTarget(self, action: Selector("pressButton"), forControlEvents: UIControlEvents.TouchDown)
        self.record.addTarget(self, action: Selector("releaseButton"), forControlEvents: UIControlEvents.TouchUpInside)
        self.call.addTarget(self, action: Selector("callUser"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @IBAction func logout(sender: AnyObject) {
        CBNetworkManager.sharedInstance().user = nil
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUsers(){
        
    }
    func pressButton()
    {
        self.micHandler.doRecordAction()
    }
    
    func releaseButton()
    {
        self.micHandler.doStopAction()
    }
    
    func callUser()
    {
        self.view.endEditing(true)
        
        let ip = self.ipaddr.text
        
        CBStreamingManager.sharedInstance().newConnection(ip!, port: 8080)
    }
    
}