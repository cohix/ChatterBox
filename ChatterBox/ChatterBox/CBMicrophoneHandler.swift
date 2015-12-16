//
//  CBMicrophoneHandler.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-11-23.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import AVFoundation

class CBMicrophoneHandler: NSObject, CBMicDelegate
{
    var audioSession: AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey : NSNumber(int: 1),
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.High.rawValue))]
    
    override init()
    {
        super.init()
        
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.audioRecorder = AVAudioRecorder(URL: self.directoryURL()!, settings: recordSettings)
            self.audioRecorder.prepareToRecord()
        }
        catch
        {
            print("Error 1");
        }
    }
    
    func directoryURL() -> NSURL?
    {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("chatterbox.m4a")
        return soundURL
    }
    
    func doRecordAction()
    {
        if !self.audioRecorder.recording
        {
            do {
                try self.audioSession.setActive(true)
                audioRecorder.record()
            }
            catch
            {
                print("Error 2")
            }
        }
    }
    
    func doStopAction() {
        self.audioRecorder.stop()
        
        do {
            try self.audioSession.setActive(false)
        }
        catch
        {
            print("Error 3")
        }
    }
}
