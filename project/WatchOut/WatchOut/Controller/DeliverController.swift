//
//  DeliverController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import simd
import CoreMotion

class DeliverController {
    
    // Manager & Controller
    private let deliverViewController: DeliverViewController
    
    private let lsManager = LightSensorManager.shared
    private let ambientIntensityObserver = AmbientIntensityObserver()
    
    private let dmManager = DeviceMotionManager.shared
    private let motionDataObserver = MotionDataObserver()
    
    private let gameManager = GameManager.shared
    
    // Variables
    private var lastMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    private var maxDiffRotRate: Double = 0.5
    private var maxDiffAcc: Double = 1.0
    
    private var accSumCounter: Double = 0.0
        
    private var timer : Timer
    private var countDownTime: Double = 0
    
    private var isAmbientIntensityDark: Bool = false
    
    init(deliverViewController: DeliverViewController) {
        self.deliverViewController = deliverViewController
        
        timer = Timer()
    }
    
    // MARK: - Delivery Logic
    
    func startDelivery(maxAccLimit: Double, countDown: Double) {
        
        let nextPlayer =  gameManager.getNextRandomPlayer()
        
        // show next player on view
        deliverViewController.nextPlayer.text = String(nextPlayer.id)
        
        // start tracking of motion
        dmManager.currentMotionData.addObserver(motionDataObserver) { newMotionData in
            
            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
            self.lastMotionData = newMotionData
            
            print("------------------------------------------------------------")
            print("Last: \(self.lastMotionData.ToString())")
            print("Diff: \(self.diffMotionData.ToString())")
            
            // check too much shaking + too shaking
            // only count acceleration if it was not too fast/much
            if (!self.aboveMaxAcceleration() && !self.aboveMaxRotationRate() ) {
                
                // Length of Difference Acceleration
                let diffAccLength = simd_length(self.diffMotionData.acceleration)
                
                self.accSumCounter += diffAccLength
                
                // Set bomb stability to percentage depending on counter
                let percentage = 1.0 - self.accSumCounter/maxAccLimit
                
                let bombExploded = !self.gameManager.bomb!.setStability(percentage: percentage)
                
                if (bombExploded) {
                    // bomb explodes
                    self.navigateToEndScreen()
                }
                else {
                    // Update Background Color
                    self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
                }
            }
        }
        
        // start tracking of light
        lsManager.ambientIntensity.addObserver(ambientIntensityObserver) { newIntensity in
            print("Intensity: \(newIntensity)")
            if (self.isAmbientIntensityDark == false && newIntensity < 700) {
                self.isAmbientIntensityDark = true
                
                // user has thumb on light sensor
            }
            
            if (self.isAmbientIntensityDark == true && newIntensity > 950) {
                self.isAmbientIntensityDark = false
                
                // user lifted thumb and delivered to next player
                
                self.navigateToNextTask()
            }
            
        }
        
        // start countdown
        startCountdown(duration: countDown)
    }
    
    /// CleansUp the delivery by stopping all observers and sensors
    private func endDelivery(stopDeviceMotion: Bool) -> Bool {
        
        stopCountdown()
        dmManager.currentMotionData.removeObserver(motionDataObserver)
        lsManager.ambientIntensity.removeObserver(ambientIntensityObserver)
        
        let lsResult = lsManager.stopLightSensor()
        
        if (stopDeviceMotion) {
            let dmResult = dmManager.stopDeviceMotion()
            
            return (lsResult && dmResult)
        }
        
        return lsResult
    }
    
    /// Returns false and handles navigation, if bomb exploded because of too fast acceleration. Also takes care of bomb stability.
    private func aboveMaxAcceleration() -> Bool {
        if (self.lastMotionData.accelerationContainsHigherAbsoluteValue(than: self.maxDiffAcc)) {
            // decrease bomb stability
            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
            
            self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
            
            if (result == false) {
                // bomb exploded
                self.navigateToEndScreen()
            }
            
            return true
        }
        else {
            return false
        }
    }
    
    /// Returns false and handles navigation, if bomb exploded because of too much rotation. Also takes care of bomb stability.
    private func aboveMaxRotationRate() -> Bool {
        if (self.lastMotionData.rotationContainsHigherAbsoluteValue(than: self.maxDiffRotRate)) {
            // decrease bomb stability
            let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
            self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.bomb!.currentColor)
            
            if (result == false) {
                // bomb exploded, show end screen
                self.navigateToEndScreen()
                return false
            }
            
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Countdown Logic
    
    private func startCountdown(duration: Double) {
        
        print("Timer started")
        
        self.countDownTime = duration
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.countDownTime -= 0.1
            
            if (self.countDownTime < 0.0) {
                // Timer ran out
                
                self.navigateToEndScreen()
            }
            else {
                self.deliverViewController.updateTimerLabel(newTime: self.countDownTime)
            }
        }
        
        // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
    }
    
    private func stopCountdown() {
        timer.invalidate()
        print("Timer stopped")
    }
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        //var nextTaskType = gameManager.switchToNextTask()
        
        if (self.endDelivery(stopDeviceMotion: false)) {
            deliverViewController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
        }
    }
    
    func navigateToHome() {
        if (self.endDelivery(stopDeviceMotion: true)) {
            deliverViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }
    
    func navigateToEndScreen() {
        if (self.endDelivery(stopDeviceMotion: true)) {
            deliverViewController.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
        }
    }
}
