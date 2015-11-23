//
//  CBMicrophoneHandler.swift
//  ChatterBox
//
//  Created by Connor MacBook on 2015-11-23.
//  Copyright © 2015 3203group. All rights reserved.
//

import Foundation
import AVFoundation

protocol CBMicrophoneHandlerDelegate
{
    func handleBuffer(data: NSData)
}

class CBMicrophoneHandler: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate
{
    var delegate: CBMicrophoneHandlerDelegate!
    
    var session: AVCaptureSession!
    var mic: AVCaptureDevice!
    var mic_input: AVCaptureDeviceInput!
    var output: AVCaptureAudioDataOutput!
    
    init(delegate: CBMicrophoneHandlerDelegate)
    {
        super.init()
        
        self.delegate = delegate
        
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetMedium
        
        self.mic = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
        self.output = AVCaptureAudioDataOutput()
        self.output.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
        do
        {
            self.mic_input = try AVCaptureDeviceInput(device: mic)
        }
        catch
        {
            return
        }
        
        self.session.addInput(self.mic_input)
        self.session.addOutput(self.output)
    }
    
    func startIfNeeded()
    {
        if !self.session.running
        {
            self.session.startRunning()
        }
    }
    
    func stopIfStarted()
    {
        if self.session.running
        {
            self.session.stopRunning()
        }
    }
    
    func toggleRunning()
    {
        if self.session.running
        {
            self.session.stopRunning()
        }
        else
        {
            self.session.startRunning()
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!)
    {
        self.sendDataToDelegate(sampleBuffer)
    }
    
    func sendDataToDelegate(buffer: CMSampleBuffer!)
    {
        let block = CMSampleBufferGetDataBuffer(buffer)
        var length = 0
        var data: UnsafeMutablePointer<Int8> = nil
        
        var status = CMBlockBufferGetDataPointer(block!, 0, nil, &length, &data)    // TODO: check for errors
        
        let result = NSData(bytes: data, length: length)
        
        self.delegate.handleBuffer(result)
    }
}
