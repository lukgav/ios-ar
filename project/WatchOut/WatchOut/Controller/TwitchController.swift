//
//  TwitchController.swift
//  WatchOut
//
//  Created by Guest User on 22/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//
import simd
import CoreMotion
import UIKit

class TwitchController {
    
    // Manager & Controller
    private var twitchViewController: TwitchViewController?
    private var twitchAltViewController: TwitchAltViewController?
    
    private let dmManager = DeviceMotionManager.shared
    private let motionDataObserver = MotionDataObserver()
    private let gameManager = GameManager.shared
    
    private var lastMotionData: MotionData = MotionData()
    
    private var accSumCounterX: Double = 0.0
    private var accSumCounterZ: Double = 0.0
    private var accSumCounterY: Double = 0.0
    
    private var maxDiff = 0.04
    private var maxDiffNeg = -0.04
        
    let twitchDirections: [TwitchDirection] = [.Up, .Down, .Left, .Right]
    
    var currentTwitchDirection : TwitchDirection
    
    var isAlt: Bool
        
    init(twitchViewController: TwitchViewController, isAlt: Bool) {
        self.twitchViewController = twitchViewController
        
        currentTwitchDirection = twitchDirections.randomElement()!
        self.isAlt = isAlt
    }
    
    init(twitchAltViewController: TwitchAltViewController, isAlt: Bool) {
        self.twitchAltViewController = twitchAltViewController
        
        currentTwitchDirection = twitchDirections.randomElement()!
        self.isAlt = isAlt
    }
      
    func startTwitch() {
        // initialize ui updates
        if(isAlt) {
            twitchAltViewController?.updateArrowImage(direction: currentTwitchDirection)
            twitchAltViewController?.updateBackgroundColor(newColor: gameManager.currentColor)
        }
        else {
            twitchViewController?.updateArrowImage(direction: currentTwitchDirection)
            twitchViewController?.updateBackgroundColor(newColor: gameManager.currentColor)
        }
        
        // wait before looking for direction
        
        var date = Date()
        date.addTimeInterval(2.0)
        let timer = Timer(fire: date, interval: 0.0, repeats: false,
                           block: { (timer) in
                                    print("START TWITCH: OBSERVE MOTION")
                            
                                    self.dmManager.currentMotionData.addObserver(self.motionDataObserver) { newMotionData in
                                    
                                    self.lastMotionData = newMotionData
                                        
                                    let lastAcc = self.lastMotionData.acceleration
                                    
                                    let lastAccX = lastAcc.x
                                    let lastAccY = lastAcc.y
                                    let lastAccZ = lastAcc.z
                                    
                                    print("-----------------------------------")
//                                    print("averageAccX:" + String(lastAccX))
//                                    print("averageAccY:" + String(lastAccY))
//                                    print("averageAccZ:" + String(lastAccZ))
                                                    
                                    var bombExploded = false
                                    var userDidWrongDirection = false
                                    
                                    switch(self.currentTwitchDirection) {
                                        case .Up:
                                            userDidWrongDirection = self.isNotUpDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                                                                    
                                        case .Right:
                                            userDidWrongDirection = self.isNotRightDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                                        
                                        case .Down:
                                            userDidWrongDirection = self.isNotDownDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                                        
                                        case .Left:
                                            userDidWrongDirection = self.isNotLeftDirection(accX: lastAccX, accY: lastAccY, accZ: lastAccZ)
                                    }
                                    
                                     // User did wrong direction
                                    if (userDidWrongDirection) {
                                        bombExploded = self.gameManager.decreaseStability(percentage: 0.03)
                                        if (bombExploded) {
                                            // Bomb exploded
                                            self.navigateToEndScreen()
                                        } else {
                                            if(self.isAlt) {
                                                self.twitchAltViewController?.updateBackgroundColor(newColor: self.gameManager.currentColor)
                                            }
                                            else {
                                                self.twitchViewController?.updateBackgroundColor(newColor: self.gameManager.currentColor)
                                            }
                                        }
                                    }
                                    // User did correct direction
                                    else {
                                        if (self.currentTwitchDirection == .Up){
                                            print("NEXT TASK")
                                            // Next Task
                                            self.navigateToNextTask()
                                        }
                                        else {
                                            print("NEXT TWITCH")
                                            // Do another Twitch
                                            self.navigateToNextTwitch()
                                        }
                                    }
                                }
                            })
        
        // Add the timer to the current run loop.
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        
        
    }
    
    private func isNotUpDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > maxDiff || accX < maxDiffNeg || accY > maxDiff || accZ > maxDiff || accZ < maxDiffNeg ) {
            print("DIRECTION UP WRONG")
            return true
        }
        print("DIRECTION UP CORRECT")
        return false
    }
    
    private func isNotRightDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > maxDiff || accY < maxDiffNeg || accY > maxDiff || accZ > maxDiff || accZ < maxDiffNeg) {
            print("DIRECTION RIGHT WRONG")
            return true
        }
        print("DIRECTION RIGHT CORRECT")
        return false
    }
    
    private func isNotDownDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX > maxDiff || accX < maxDiffNeg || accY < maxDiffNeg || accZ > maxDiff || accZ < maxDiffNeg) {
            print("DIRECTION DOWN WRONG")
            return true
        }
        print("DIRECTION DOWN CORRECT")
        return false
    }
    
    private func isNotLeftDirection(accX: Double, accY: Double, accZ: Double) -> Bool {
        if (accX < maxDiffNeg || accY < maxDiffNeg || accY > maxDiff || accZ > maxDiff || accZ < maxDiffNeg) {
            print("DIRECTION LEFT WRONG")
            return true
        }
        print("DIRECTION LEFT CORRECT")
        return false
    }
    
    private func endTwitch(stopDeviceMotion: Bool) -> Bool {
        dmManager.currentMotionData.removeObserver(motionDataObserver)
        
        if(stopDeviceMotion) {
            let dmResult = dmManager.stopDeviceMotion()
            return dmResult
        }
        return true
    }
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        if (self.endTwitch(stopDeviceMotion: false)) {
            if(isAlt) {
                twitchAltViewController?.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
            }
            else {
                twitchViewController?.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
            }
            
        }
    }

    func navigateToHome() {
        if (self.endTwitch(stopDeviceMotion: true)) {
            if(self.isAlt) {
                twitchAltViewController?.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
            }
            else {
                twitchViewController?.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
            }
        }
    }

    func navigateToEndScreen() {
        if (self.endTwitch(stopDeviceMotion: true)) {
            if(self.isAlt) {
                twitchAltViewController?.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
            }
            else {
                twitchViewController?.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
            }
        }
    }
    
    func navigateToNextTwitch() {
        if (self.endTwitch(stopDeviceMotion: false)){
            if(self.isAlt) {
                 twitchAltViewController?.performSegue(withIdentifier: Constants.TwitchSegue, sender: self)
             }
             else {
                 twitchViewController?.performSegue(withIdentifier: Constants.TwitchAltSegue, sender: self)
             }
        }
    }
}
