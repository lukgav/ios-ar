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
    
    private var thresholdRotRate: Double = 0.05
    private var thresholdAcc: Double = 0.05
    
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
            
            // too much shaking
            if (true) {
                
            }
            
            // too fast
            if (true) {
                
            }
            
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
    
    func endDelivery() {
        dmManager.currentMotionData.removeObserver(observer)
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
