//
//  CBAudioPlayer.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-11-23.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import AVFoundation

class CBAudioPlayer: NSObject
{
    var audioPlayer:AVAudioPlayer!
    
    var delegate: CBMicDelegate!
    
    init(delegate: CBMicDelegate)
    {
        super.init()
        
        self.delegate = delegate
    }
    
    func doPlayAction()
    {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: delegate.directoryURL()!)

            self.audioPlayer.play()
        }
        catch
        {
            print("Error 4")
        }
    }
}