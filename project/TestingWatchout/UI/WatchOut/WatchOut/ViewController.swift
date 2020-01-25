//
//  ViewController.swift
//  WatchOut
//
//  Created by iOS1920 on 08.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Playercount
    
    @IBOutlet weak var player: UILabel!
    
    
    @IBAction func playerCount(_ sender: UIStepper) {
        player.text = String(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func stepper(_ sender: Any) {
        
    }
    
    
}

