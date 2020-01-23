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
    
    private var maxDiffRotRate: Double = 5.0
    private var maxDiffAcc: Double = 3.0
    
    private var minDiffRotRate: Double = 1.0
    private var minDiffAcc : Double = 0.5
        
    private var timer : Timer
    private var countDownTime: Double = 0
    private var timerInterval: Double = 1/10.0
    
    private var ignoreCounter: Int = 0
    private let ignoreCount: Int = 2
    private var isAmbientIntensityDark: Bool = false
    
    init(deliverViewController: DeliverViewController) {
        self.deliverViewController = deliverViewController
        
        timer = Timer()
    }
    
    // MARK: - Delivery Logic
    
    func startDelivery(countDownDuration: Double) {
        
        let nextPlayer =  gameManager.getNextRandomPlayer()
        
        // initialize UI
        deliverViewController.updatePlayerNameLabel(name: nextPlayer.name)
        deliverViewController.updateTimerLabel(newTime: countDownDuration)
        deliverViewController.updateBackgroundColor(newColor: gameManager.currentColor)
        
        // start tracking of motion
        dmManager.currentMotionData.addObserver(motionDataObserver) { newMotionData in
            
            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
            self.lastMotionData = newMotionData
            
            print("------------------------------------------------------------")
            //print("Last: \(self.lastMotionData.ToString())")
            //print("Diff: \(self.diffMotionData.ToString())")
              
            if(self.checkAcceleration(newDiffAcc: self.diffMotionData.acceleration))
            {
                // Bomb exploded because of Acceleration
                self.navigateToEndScreen()
            }
            
            if(self.checkRotationRate(newDiffRotationRate: self.diffMotionData.rotationRate))
            {
                // Bomb exploded because of RotationRate
                self.navigateToEndScreen()
            }
            
            // Bomb is alive, update the color
            self.deliverViewController.updateBackgroundColor(newColor: self.gameManager.currentColor)
        }
        
        // start tracking of light
        
        let lightSensorOn = lsManager.startLightSensor()
        if(lightSensorOn) {
            lsManager.ambientIntensity.addObserver(ambientIntensityObserver) { newIntensity in
                // Ignore first values, because of light change on beginning
                if (self.ignoreCounter > self.ignoreCount) {
                    print("Intensity: \(newIntensity)")
                    if (self.isAmbientIntensityDark == false &&
                       newIntensity < 750) {
                       
                       self.isAmbientIntensityDark = true
                       
                       // user has thumb on light sensor
                       print("THUMB NOW ON SENSOR")
                   }
                   
                   if (self.isAmbientIntensityDark == true && newIntensity > 1000) {
                       self.isAmbientIntensityDark = false
                       
                       // user lifted thumb and delivered to next player
                       print("THUMB LEFT THE SENSOR")
                       self.navigateToNextTask()
                   }
                }
                else {
                    print("Ignored Intensity: \(newIntensity)")
                    self.ignoreCounter += 1
                }
               
            }
        }
        
        // start countdown
        self.startCountdown(duration: countDownDuration)
    }
    
    /// CleansUp the delivery by stopping all observers and sensors
    private func endDelivery(stopDeviceMotion: Bool) -> Bool {
        print("END DELIVERY")
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
    
    private func checkAcceleration(newDiffAcc: SIMD3<Double>) -> Bool {
        let diffAccLength = abs(simd_length(self.diffMotionData.acceleration))
        
        //print("diffAccLength: \(diffAccLength)")
        
        // Explode when higher than maxDiff
        if(diffAccLength >= self.maxDiffAcc) {
            print("Acceleration BIG Error")
            
            let result = self.gameManager.decreaseStability(percentage: 0.1)
            return result
        }
            
        // Error when between minDiff and MaxDiff
        else if(diffAccLength >= self.minDiffAcc) {
            print("Acceleration LITTLE Error")
            
            // calculate percentage depending on how big the error is
            // e.g. fixed 1% * relative error between min and max (also %)
            let percentage = (diffAccLength - self.minDiffAcc)/(self.maxDiffAcc - self.minDiffAcc)*0.1
            let result = self.gameManager.decreaseStability(percentage: percentage)
            
            return result
        }
            
        // No Error when below minDiff
        else {
            print("Acceleration NO Error")
            
            return false
        }
    }
    
    /// Returns true, if bomb exploded
    private func checkRotationRate(newDiffRotationRate: SIMD3<Double>) -> Bool {
        let diffRotRateLength = abs(simd_length(self.diffMotionData.rotationRate))
        
        //print("diffRotRateLength: \(diffRotRateLength)")
        
        // Explode when higher than maxDiff
        if(diffRotRateLength >= self.maxDiffRotRate) {
            print("Rotation BIG Error")
            
            let result = self.gameManager.decreaseStability(percentage: 0.05)
            return result
        }
            
        // Error when between minDiff and MaxDiff
        else if(diffRotRateLength >= self.minDiffRotRate) {
            print("Rotation LITTLE Error")
            
            // calculate percentage depending on how big the error is
            // e.g. fixed 1% * relative error between min and max (also %)
            let percentage = (diffRotRateLength - self.minDiffRotRate)/(self.maxDiffRotRate - self.minDiffRotRate)*0.05
            let result = self.gameManager.decreaseStability(percentage: percentage)
            
            return result
        }
            
        // No Error when below minDiff
        else {
            print("Rotation NO Error")
            
            return false
        }
    }
        
    // MARK: - Countdown Logic
    
    private func startCountdown(duration: Double) {
        
        print("Timer started")
        
        self.countDownTime = duration
        
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timerInterval, repeats: true) { timer in
            self.countDownTime -= self.timerInterval
            
            if (self.countDownTime < 0.0) {
                // Timer ran out
                
                self.navigateToEndScreen()
            }
            else {
                if (self.countDownTime < duration - self.timerInterval*5) {
                    print("CAN PUT FINGER ON LIGHT SENSOR")
                }
                
                //print("CountDownTime: \(self.countDownTime)")
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
        print("END")
        if (self.endDelivery(stopDeviceMotion: true)) {
            deliverViewController.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
        }
    }
}
