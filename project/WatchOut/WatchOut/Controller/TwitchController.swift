////
////  TwitchController.swift
////  WatchOut
////
////  Created by Guest User on 22/01/2020.
////  Copyright © 2020 iOS1920. All rights reserved.
////
//
//import simd
//import CoreMotion
//
//class TwitchController {
//    
//    // Manager & Controller
//    private let twitchViewController: TwitchViewController
//    
//    private let dmManager = DeviceMotionManager.shared
//    private let motionDataObserver = MotionDataObserver()
//    private let gameManager = GameManager.shared
//    
//    private var lastMotionData: MotionData = MotionData()
//    private var diffMotionData: MotionData = MotionData()
//    
//    private var maxDiffRotRate: Double = 0.05
//    private var maxDiffAcc: Double = 0.5
//    
//    private var accSumCounter: Double = 0.0
//    
//    var myArrows: [String] = ["left-arrow", "right-arrow", "up-arrow", "down-arrow"]
//    
//    init(twitchViewController: TwitchViewController) {
//        self.twitchViewController = twitchViewController
//    }
//    
//    func startTwitchToLeft(maxMovingSpeed: Double) {
//        dmManager.currentMotionData.addObserver(motionDataObserver) { newMotionData in
//            
//            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
//            self.lastMotionData = newMotionData
//            
//            // copy the moving of arrow but dont move too fast and so shaking
//            if(!self.aboveMaxAcceleration() && !self.aboveMaxRotationRate()) {
//                
//                // check if the phone move to the left
//        
//                let diffAccLength = self.diffMotionData.acceleration.x
//                //if (diffAccLength > 0)
//                self.accSumCounter += diffAccLength
//                    
//                    // Set bomb stability to percentage depending on counter
//                    let percentage = self.accSumCounter/maxMovingSpeed
//                    
//                    let result = self.gameManager.bomb?.setStability(percentage: percentage)
//                    
//                    if (result!) {
//                        //bomb explodes
//                        self.navigateToEndScreen()
//                    } else {
//                        self.twitchViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
//                    }
//                }
//            
//            
//        }
//        
//    }
//    
//    private func endTwtich(stopDeviceMotion: Bool) -> Bool {
//        dmManager.currentMotionData.removeObserver(motionDataObserver)
//        
//        if(stopDeviceMotion) {
//            let dmResult = dmManager.stopDeviceMotion()
//            return dmResult
//        }
//        return false
//    }
//    
//    /// Returns false and handles navigation, if bomb exploded because of too fast acceleration. Also takes care of bomb stability.
//    private func aboveMaxAcceleration() -> Bool {
//        if (self.lastMotionData.accelerationContainsHigherAbsoluteValue(than: self.maxDiffAcc)) {
//            // decrease bomb stability
//            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
//            self.twitchViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
//            
//            if (result == false) {
//                // bomb exploded
//                self.navigateToEndScreen()
//            }
//            
//            return true
//        }
//        else {
//            return false
//        }
//    }
//    
//    /// Returns false and handles navigation, if bomb exploded because of too much rotation. Also takes care of bomb stability.
//    private func aboveMaxRotationRate() -> Bool {
//        if (self.lastMotionData.rotationContainsHigherAbsoluteValue(than: self.maxDiffRotRate)) {
//            // decrease bomb stability
//            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
//            self.twitchViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
//            
//            if (result == false) {
//                // bomb exploded, show end screen
//                self.navigateToEndScreen()
//                        return false
//            }
//            
//            return true
//        }
//        else {
//            return false
//        }
//    
//    }
//    // MARK: - Navigation
//    
//    func navigateToNextTask() {
//        //var nextTaskType = gameManager.switchToNextTask()
//        
//        if (self.endTwtich(stopDeviceMotion: false)) {
//            twitchViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
//        }
//    }
//
//    func navigateToHome() {
//        if (self.endTwtich(stopDeviceMotion: true)) {
//            twitchViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
//        }
//    }
//
//    func navigateToEndScreen() {
//        if (self.endTwtich(stopDeviceMotion: true)) {
//            twitchViewController.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
//        }
//    }
//    
//}
