//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class UnwrapController : CustomController {
 
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
        
        
    // MARK: - Unwrap Logic
    
    func startTest() {
        dmManager.currentMotionData.addObserver(observer) { newData in
            print("Gravity")
            print(newData.gravity)
        }
    }
        
    func stopTest() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
    }
    
    
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        var nextTaskType = gameManager.switchToNextTask()
        
        
    }
    
    func navigateToHome() {
        var result = dmManager.stopDeviceMotion()
        if (result) {
            navigationController.performSegue(withIdentifier: Constants.QuitGameSegue, sender: self)
        }
    }
}
