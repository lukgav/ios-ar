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
        
    
    private var lastAtt: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    private var lastAcc: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    private var lastGrav: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    private var lastRotRate: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    
    private var diffAtt: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    private var diffAcc: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    private var diffGrav: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    private var diffRotRate: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    
    private var thresholdRotRate: Double = 0.05
    private var thresholdAcc: Double = 0.05
    
    init(unwrapViewController: UnwrapViewController) {
        self.unwrapViewController = unwrapViewController
    }
    
    // MARK: - Unwrap Logic
    
    func StartUnwrapX() {
        
    }
    
    func startUnwrapAroundZ() {
        dmManager.currentMotionData.addObserver(observer) { newData in
            print(newData.gravity)
        
            self.diffAtt = newData.attitude - self.lastAtt
            self.diffRotRate = newData.rotationRate - self.lastRotRate
            self.diffGrav = newData.gravity - self.lastGrav
            self.diffAcc = newData.acceleration - self.lastAcc
            
            self.lastAtt = newData.attitude
            self.lastAcc = newData.acceleration
            self.lastGrav = newData.gravity
            self.lastRotRate = newData.rotationRate
            
            
            print("Last: Att: \(self.lastAtt), Acc: \(self.lastRotRate), Att: \(self.lastGrav), Att: \(self.lastAcc))")
            print("Diff: Att: \(self.diffAtt), Acc: \(self.diffRotRate), Att: \(self.diffGrav), Att: \(self.diffAcc))")
            
            // too much shaking
            if (true) {
                
            }
            
            // too fast
            if (true) {
                
            }
            
            
        }
    }
        
    func stopUnwrapX() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
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
