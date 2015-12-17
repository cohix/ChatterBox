//
//  ViewController.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-11-11.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate
{
    var micHandler: CBMicrophoneHandler!
    var connectionSocket: CBConnectionSocket!
    
    var micButton: UIButton!
    var hostField: UITextField!
    var callButton: UIButton!
    var youLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.addRecordButton()
        self.addHostField()
        self.addCallButton()
        self.addYouLabel()
        
        self.micHandler = CBMicrophoneHandler()
        
        self.connectionSocket = CBConnectionSocket()
        self.connectionSocket.start()
    }
    
    func addHostField()
    {
        self.hostField = UITextField(frame: CGRect(x: 20, y: 200, width: self.view.frame.width - 40, height: 60))
        self.hostField.placeholder = "Call an IP address"
        
        self.view.addSubview(self.hostField)
    }
    
    func addYouLabel()
    {
        self.youLabel = UILabel(frame: CGRect(x: 20, y: 50, width: self.view.frame.width - 40, height: 60))
        self.youLabel.text = "Your IP address is: \(CBStreamingManager.sharedInstance().getWiFiAddress()!)"
        self.youLabel.font = UIFont.systemFontOfSize(16)
        
        self.view.addSubview(self.youLabel)
    }
    
    func addCallButton()
    {
        self.micButton = UIButton(frame: CGRect(x: 20, y: 300, width: self.view.frame.width - 40, height: 60))
        self.micButton.setTitle("Call", forState: .Normal)
        self.micButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.micButton.addTarget(self, action: Selector("callUser"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.micButton)
    }
    
    func addRecordButton()
    {
        self.micButton = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, height: 60))
        self.micButton.setTitle("Record", forState: .Normal)
        self.micButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.micButton.addTarget(self, action: Selector("pressButton"), forControlEvents: UIControlEvents.TouchDown)
        self.micButton.addTarget(self, action: Selector("releaseButton"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.micButton)
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
        
        let ip = self.hostField.text
        
        CBStreamingManager.sharedInstance().newConnection(ip!, port: 8080)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

