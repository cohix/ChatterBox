//
//  CBAudioPlayer.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-11-23.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import AVFoundation

class CBAudioPlayer: NSObject, CBAudioBufferDelegate
{
    var engine: AVAudioEngine!
    var playerNode: AVAudioPlayerNode!
    var mixer: AVAudioMixerNode!
    
    override init()
    {
        super.init()
        
        self.setup()
        self.start()
    }
    
    func handleBuffer(data: NSData)
    {
        let newBuffer = self.toPCMBuffer(data)
        print(newBuffer)
        
        self.playerNode.scheduleBuffer(newBuffer, completionHandler: nil)
    }
    
    func setup()
    {
        self.engine = AVAudioEngine()
        self.playerNode = AVAudioPlayerNode()
        
        self.engine.attachNode(self.playerNode)
        self.mixer = engine.mainMixerNode
        
        engine.connect(self.playerNode, to: self.mixer, format: self.mixer.outputFormatForBus(0))
    }
    
    func start()
    {
        do {
            try self.engine.start()
        }
        catch {
            print("error couldn't start engine")
        }
        
        self.playerNode.play()
    }
    
    func toPCMBuffer(data: NSData) -> AVAudioPCMBuffer
    {
        let audioFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.PCMFormatFloat32, sampleRate: 8000, channels: 2, interleaved: false)  // given NSData audio format
        let PCMBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: UInt32(data.length) / audioFormat.streamDescription.memory.mBytesPerFrame)
        
        PCMBuffer.frameLength = PCMBuffer.frameCapacity
        
        let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: Int(PCMBuffer.format.channelCount))
        
        data.getBytes(UnsafeMutablePointer<Int8>(channels[0]) , length: data.length)
        
        return PCMBuffer
    }
}