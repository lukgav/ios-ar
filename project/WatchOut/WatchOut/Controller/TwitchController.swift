//
//  TwitchController.swift
//  WatchOut
//
//  Created by Guest User on 22/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//
import simd
import CoreMotion

class TwitchController {
    
    // Manager & Controller
    private let twitchViewController: TwitchViewController
    
    private let dmManager = DeviceMotionManager.shared
    private let motionDataObserver = MotionDataObserver()
    private let gameManager = GameManager.shared
    
    private var lastMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    private var maxDiffRotRate: Double = 0.05
    private var maxDiffAcc: Double = 0.5
    
    private var accSumCounterX: Double = 0.0
    private var accSumCounterZ: Double = 0.0
    private var accSumCounterY: Double = 0.0
    
    let twitchDirections: [TwitchDirection] = [.Up]
    
    var currentTwitchDirection : TwitchDirection
    var currentDirectionDone: Bool = false
    
    var twitchDoneCounter: Int = 0
    
    var accArray: [SIMD3<Double>] = Array(repeating: SIMD3<Double>(0.0,0.0,0.0), count: 20)
    var intervalCounter: Int = 0
    
    var maxPosSpeed: Double = 0.0
    var maxNegSpeed: Double = 0.0
    var minDirectionSpeed: Double = 0.0
    
    init(twitchViewController: TwitchViewController) {
        self.twitchViewController = twitchViewController
        
        currentTwitchDirection = twitchDirections.randomElement()!
    }
      
    func startTwitch(maxMovingSpeed: Double, amount: Int) {
        
        maxPosSpeed = maxMovingSpeed
        maxNegSpeed = maxMovingSpeed * -1.0
        minDirectionSpeed = maxMovingSpeed * 0.1
        
        // initialize ui updates
        twitchViewController.updateArrowImage(direction: currentTwitchDirection)
        
        dmManager.currentMotionData.addObserver(motionDataObserver) { newMotionData in
            
            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
            self.lastMotionData = newMotionData
            
            self.accArray[self.intervalCounter] = self.diffMotionData.acceleration
            if(self.intervalCounter >= self.accArray.count-1) {
                self.intervalCounter = 0
                
                var accSum: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
                for acc in self.accArray {
                    accSum += acc
                }
                let averageAcc = accSum
                
                let lastAccX = averageAcc.x
                let lastAccY = averageAcc.y
                let lastAccZ = averageAcc.z
                
                print("-----------------------------------")
                print("averageAccX:" + String(lastAccX))
                print("averageAccY:" + String(lastAccY))
                print("averageAccZ:" + String(lastAccZ))
                
                if(!self.currentDirectionDone) {
                    
                    var bombExploded = false
                    var userDidCorrectDirection = false
                    
                    switch(self.currentTwitchDirection) {
                        case .Up:
                            userDidCorrectDirection = self.isUpDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                                                    
                        case .Right:
                            userDidCorrectDirection = self.isRightDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                        
                        case .Down:
                            userDidCorrectDirection = self.isDownDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                        
                        case .Left:
                            userDidCorrectDirection = self.isLeftDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                    }
                    
                    // User did correct direction
//                    if (userDidCorrectDirection) {
//                        self.currentDirectionDone = true
//                    }
//                    // User did wrong direction
//                    else {
//                        bombExploded = self.gameManager.decreaseStability(percentage: 0.25)
//
//                        if (bombExploded) {
//                            // Bomb exploded
//                            self.navigateToEndScreen()
//                        } else {
//                            self.twitchViewController.updateBackgroundColor(newColor: self.gameManager.currentColor)
//                        }
//                    }
                }
                // TwitchDirectionDone = true
//                else {
//                    if (self.twitchDoneCounter > amount) {
//                        // Next Task
//                        self.navigateToNextTask()
//                    }
//                    else {
//                        // Next Twitch
//                        self.currentDirectionDone = false
//                        self.twitchDoneCounter += 1
//                        self.currentTwitchDirection = self.twitchDirections.randomElement()!
//                        // Update UI
//                        self.twitchViewController.updateArrowImage(direction: self.currentTwitchDirection)
//                    }
//                }
            }
            else {
                self.intervalCounter += 1
            }
        }
    }
    
    private func isUpDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > maxNegSpeed && accX < maxPosSpeed && accY > minDirectionSpeed && accZ > maxNegSpeed && accZ < maxPosSpeed) {
            print("DIRECTION UP CORRECT")
            return true
        }
        print("DIRECTION UP WRONG")
        return false
    }
    
    private func isRightDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > 0.1 || accY > 0.1 || accZ > 0.1) {
            return true
        }
        return false
    }
    
    private func isDownDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > 0.1 || accY > 0.1 || accZ > 0.1) {
            return true
        }
        return false
    }
    
    private func isLeftDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > 0.1 || accY > 0.1 || accZ > 0.1) {
            return true
        }
        return false
    }
    
    private func endTwitch(stopDeviceMotion: Bool) -> Bool {
        dmManager.currentMotionData.removeObserver(motionDataObserver)
        
        if(stopDeviceMotion) {
            let dmResult = dmManager.stopDeviceMotion()
            return dmResult
        }
        return false
    }
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        if (self.endTwitch(stopDeviceMotion: false)) {
            twitchViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
        }
    }

    func navigateToHome() {
        if (self.endTwitch(stopDeviceMotion: true)) {
            twitchViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }

    func navigateToEndScreen() {
        if (self.endTwitch(stopDeviceMotion: true)) {
            twitchViewController.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
        }
    }
}
