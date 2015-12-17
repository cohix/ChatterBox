//
//  SimpleCallViewController.swift
//  ChatterBox
//
//  Created by Savanna on 12/9/15.
//  Copyright © 2015 3203group. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleCallViewController: UIViewController
{
    var micHandler: CBMicrophoneHandler!
    var audioPlayer: CBAudioPlayerOperation!
    
    @IBOutlet weak var refresh: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var users: UITableView!
    @IBOutlet weak var logout: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.start()
    }
    
    @IBAction func logout(sender: AnyObject) {
        CBNetworkManager.sharedInstance().user = nil
    }
    
    func start()
    {
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}