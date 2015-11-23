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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.audioPlayer = CBAudioPlayer()
        self.micHandler = CBMicrophoneHandler(delegate: self.audioPlayer)
        
        self.start()
    }
    
    func start()
    {
        self.micHandler.startIfNeeded()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

