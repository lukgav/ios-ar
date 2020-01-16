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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        controller = DeliverController(deliverController: self)
    }
    
    @IBAction func NextTaskTouch(_ sender: Any) {
        controller?.navigateToNextTask()
    }
    
    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
}
