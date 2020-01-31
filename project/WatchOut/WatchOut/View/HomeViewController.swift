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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = HomeController(homeViewController: self)
        controller?.startGame()
    }
    
    @IBAction func playerCountStepperValueChanged(_ sender: UIStepper) {
        controller!.playerCount = Int(sender.value)
        playerCountLabel.text = String(controller!.playerCount)
    }
    
    @IBAction func StartButtonTouch(_ sender: Any) {
        controller!.navigateToFirstTask()
    }
    
    @IBAction func HelpButtonTouch(_ sender: Any) {
        controller!.navigateToHelp()
    }

}

