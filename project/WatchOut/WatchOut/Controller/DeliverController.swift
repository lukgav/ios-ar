//
//  DeliverController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import simd

class DeliverController {
    
    private let deliverViewController: DeliverViewController
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
        
    
    private var lastMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    private var maxRotRate: Double = 0.05
    private var maxAcc: Double = 0.5
    
    private var accSumCounter: Double = 0.0
    
    init(deliverViewController: DeliverViewController) {
        self.deliverViewController = deliverViewController
    }
    
    // add player parameter later
    func startDelivery(maxAccLimit: Double) {
        dmManager.currentMotionData.addObserver(observer) { newMotionData in
            self.lastMotionData = newMotionData
            
            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
            
            print("------------------------------------------------------------")
            print("Last: \(self.lastMotionData.ToString())")
            print("Diff: \(self.diffMotionData.ToString())")
            
            // too much shaking + too shaking
            if (self.checkMaxAcceleration() && self.checkMaxRotationRate() ) {
                let diffAccLength = simd_length(self.diffMotionData.acceleration)
                
                self.accSumCounter += diffAccLength
                
                let percentage = self.accSumCounter/maxAccLimit
                
                let result = self.gameManager.bomb!.setStability(percentage: percentage)
                self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
                
                if (result) {
                    // bomb explodes
                    
                    self.endDelivery()
                }
            }
        }
    }
    
    func endDelivery() {
        dmManager.currentMotionData.removeObserver(observer)
    }
    
    // too fast
    func checkMaxAcceleration() -> Bool {
        if (self.lastMotionData.accelerationContainsHigherAbsoluteValue(than: self.maxAcc)) {
            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
            self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
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
    
    // too shaking
    func checkMaxRotationRate() -> Bool {
        if (self.lastMotionData.rotationContainsHigherAbsoluteValue(than: self.maxRotRate)) {
            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
            self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
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
        
        deliverViewController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
    }
    
    func navigateToHome() {
        let result = dmManager.stopDeviceMotion()
        if (result) {
            deliverViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }
}
