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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupMicrophone()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupMicrophone()
    {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        let mic = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        var mic_input: AVCaptureDeviceInput!
        
        let audio_output = AVCaptureAudioDataOutput()
        audio_output.setSampleBufferDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        
        do
        {
            mic_input = try AVCaptureDeviceInput(device: mic)
        }
        catch
        {
            return
        }
        
        session.addInput(mic_input)
        session.addOutput(audio_output)
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!)
    {
        print("hello")
    }
}

