//
//  ViewController.swift
//  WatchOut
//
//  Created by iOS1920 on 08.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
    
    @IBOutlet weak var playerCountLabel: UILabel!
    
    @IBAction func playerCountStepperValueChanged(_ sender: UIStepper) {
        playerCountLabel.text = String(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

