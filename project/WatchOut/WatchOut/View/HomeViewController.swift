//
//  ViewController.swift
//  WatchOut
//
//  Created by iOS1920 on 08.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
    
    var controller: HomeController?
    
    @IBOutlet weak var playerCountLabel: UILabel!
    
    @IBAction func playerCountStepperValueChanged(_ sender: UIStepper) {
        playerCountLabel.text = Int(sender.value).description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        controller = HomeController()
        
        print("Hello")
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        
        // how many players
        //switch playerCountLabel.text {
        //case 1:
        //    ...
        //case 5:
        //}
    }
    
    
    @IBAction func helpButton(_ sender: UIButton) {
        // goes to help screen
    }
    
    // Navigation to first Task
    
    // Navigation to Help
    
}

