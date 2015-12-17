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
        print(self.url)
    }
    
    override func main()
    {
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: self.url, fileTypeHint: AVFileTypeAppleM4A)

            self.audioPlayer.play()
        }
        catch let err as NSError
        {
            print("Error 4")
            print(err.localizedDescription)
        }
    }
}