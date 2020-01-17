//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class UnwrapController {
 
    private let unwrapViewController : UnwrapViewController
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
        
    
    private var lastMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    private var maxRotRate: Double = 0.05
    private var maxAcc: Double = 0.05
    
    init(unwrapViewController: UnwrapViewController) {
        self.unwrapViewController = unwrapViewController
    }
    
    // MARK: - Unwrap Logic
    
    func StartUnwrapX() {
        
    }
    
    
    /// Starting position is when the phone is facing towards the user (x=0,y=-1,z=0)
    func startUnwrapAroundZ() {
        dmManager.currentMotionData.addObserver(observer) { newMotionData in
            
            self.lastMotionData = newMotionData
            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
            
            print("------------------------------------------------------------")
            print("Last: \(self.lastMotionData.ToString())")
            print("Diff: \(self.diffMotionData.ToString())")
            
            if(self.checkMaxAcceleration() && self.checkMaxRotationRate()) {
                
            }
        }
    }
    
    func stopUnwrapX() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
    }
    
    func checkMaxAcceleration() -> Bool {
        // too much acceleration (shaking)
        if (self.lastMotionData.accelerationContainsHigherAbsoluteValue(than: self.maxAcc)) {
            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
            self.unwrapViewController.updateBackgroundColor(color: self.gameManager.bomb!.currentColor)
            if (result == false) {
                    // bomb exploded, show end screen
                    return false
                }
                
                return true
        }
        else {
            return false
        }
    }
    
    func checkMaxRotationRate() -> Bool {
        // too fast rotation (speed)
        if (self.lastMotionData.rotationContainsHigherAbsoluteValue(than: self.maxRotRate)) {
            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
            self.unwrapViewController.updateBackgroundColor(color: self.gameManager.bomb!.currentColor)
            if (result == false) {
                // bomb exploded, show end screen
                return false
            }
            
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        //var nextTaskType = gameManager.switchToNextTask()
        
        unwrapViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
    }
    
    func navigateToHome() {
        let result = dmManager.stopDeviceMotion()
        if (result) {
            unwrapViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }
}
