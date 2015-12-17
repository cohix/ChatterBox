//
//  MeshCallViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/9/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation

class MeshCallViewController: UIViewController
{
    var micHandler: CBMicrophoneHandler!
    
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var new: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.audioPlayer = CBAudioPlayer()
        self.micHandler = CBMicrophoneHandler()
        self.start()
        
    }
    
    @IBAction func newCall(sender: AnyObject) {
        
    }
    @IBAction func logout(sender: AnyObject) {
        //NetworkAccessor.sharednetwork.network.user = nil
    }
   
    func start()
    {
        self.micHandler.doRecordAction()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}