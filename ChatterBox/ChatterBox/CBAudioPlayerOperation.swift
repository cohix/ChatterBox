//
//  CBAudioPlayer.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-11-23.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import AVFoundation

class CBAudioPlayerOperation: NSOperation
{
    var audioPlayer:AVAudioPlayer!
    
    var url: NSURL!
    
    init(url: NSURL)
    {
        self.url = url
    }
    
    override func main()
    {
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: self.url)

            self.audioPlayer.play()
        }
        catch
        {
            print("Error 4")
        }
    }
}