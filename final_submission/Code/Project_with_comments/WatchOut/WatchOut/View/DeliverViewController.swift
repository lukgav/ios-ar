//
//  DeliverViewController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class DeliverViewController: UIViewController {

    var controller: DeliverController?
    
    @IBOutlet weak var nextPlayer: UILabel!
    @IBOutlet weak var countDownTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        controller = DeliverController(deliverViewController: self)
        
        // start the delivery with the desired countdown
        controller?.startDelivery(countDownDuration: 10.0)
    }
    
    // quit the game and navigate to home
    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    
    // for updating the backgroundColor from the controller level
    func updateBackgroundColor(newColor: UIColor) {
        self.view.backgroundColor = newColor
    }
    
    // for updating the timerLabel from the controller level
    func updateTimerLabel(newTime: Double) {
        // shows one decimal
        countDownTimeLabel.text = String(Double(round(10*newTime)/10))
    }
    
    // for updating the playerNameLabel from the controller level
    func updatePlayerNameLabel(name: String) {
        nextPlayer.text = name
    }
}
