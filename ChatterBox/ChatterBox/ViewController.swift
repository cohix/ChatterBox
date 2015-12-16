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
    var audioPlayer: CBAudioPlayer!
    
    var micButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.addButton()
        
        self.micHandler = CBMicrophoneHandler()
        //self.audioPlayer = CBAudioPlayer()
    }
    
    func addButton()
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
        //self.audioPlayer.doPlayAction()
    }
    
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

