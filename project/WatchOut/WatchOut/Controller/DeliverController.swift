//
//  DeliverController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class DeliverController {
    
    let dmManager = DeviceMotionManager.shared
    let observer = MotionDataObserver()
    let gameManager = GameManager.shared

    let deliverController: DeliverViewController
    
    init(deliverController: DeliverViewController) {
        self.deliverController = deliverController
    }
    
    func startDelivery(forPlayer: Player) {
        
    }
    
    func endDelivery() {
        
    }
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        //var nextTaskType = gameManager.switchToNextTask()
        
        deliverController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
    }
    
    func navigateToHome() {
        let result = dmManager.stopDeviceMotion()
        if (result) {
            deliverController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }
}
