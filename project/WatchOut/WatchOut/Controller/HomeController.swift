//
//  HomeController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class HomeController : CustomController {
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
        
    var playerCount: Int = 1
        
    // MARK: - Navigation
    
    func navigateToFirstTask() {
        gameManager.startNewGame(playerCount: playerCount)
        let result = dmManager.startDeviceMotion()
        
        if (result) {
            switch(gameManager.currentTask) {
                case .Unwrap:
                    navigationController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
                case .Deliver:
                    navigationController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
                case .none:
                    return
            }
        }
    }
    
    func navigateToHelp() {
        navigationController.performSegue(withIdentifier: Constants.HelpSegue, sender: self)
    }
}
