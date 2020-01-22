//
//  bombManager.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 13.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation
import UIKit

class Bomb{
    let stabilityLimit: Double
    var stabilityCounter: Double {
        didSet {
            // change color everytime stabiltyCounter value changed
            stabilityChanged()
            print("StabilityCounter changed from \(oldValue) to \(stabilityCounter)")
            print("Color: \(currentColor)")
        }
    }
    
    var decreaseOverTime: Bool
    
    var currentColor: UIColor
    
    var hasExploded: Bool = false
    
    let timeLimit: Double
    var timer: Timer?
    var currentTime: Double
    
    // precision of the timer
    let timeInterval = 1.0/50.0
    
    init(stabilityLimit: Double, timeLimit: Double, decreaseOverTime: Bool = true){
        self.stabilityLimit = stabilityLimit
        self.timeLimit = timeLimit
        self.decreaseOverTime = decreaseOverTime
        
        currentTime = 0.0
        // counter starts full and will decrease over time
        stabilityCounter = stabilityLimit
        
        currentColor = UIColor.white
    }
    /// Stops the bomb timer
    func stopTimer() {
        // delete the old timer object and create a new one
        // when the timer should start counting again
        timer?.invalidate()
        timer = nil
    }
    
    /// Starts the bomb timer
    func startTimer() {
        // only start a new timer if none exists
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            // add time to currentTime every 1/50 secs (timeInterval)
            self.currentTime += self.timeInterval
        }
    }
        
    /// Returns false, if the bomb exlodes after decreasing the stability
    func decreaseStability(percentage: Double) -> Bool{
        self.stabilityCounter -= percentage*stabilityLimit
        
        if (self.stabilityCounter < 0.0) {
            return false
        }
        
        return true
    }
    
    /// If the added percentage is higher than the StabilityLimit, it will only increase to the StabilityLimit
    func increaseStability(percentage: Double) {
        let increaseAmount = percentage*stabilityLimit
        
        // only increase to a maximum of the stabilyLimit
        if(self.stabilityCounter + increaseAmount >= stabilityLimit) {
            self.stabilityCounter = stabilityLimit
        }
        else {
            self.stabilityCounter += increaseAmount
        }
    }
    
    /// Returns false, if the bomb explodes when setting the new percentage
    /// percentage should be between 0.0 and 1.0
    func setStability(percentage: Double) -> Bool {
        if (percentage > 0.0 && percentage < 1.0) {
            let newStability = percentage*stabilityLimit
            self.stabilityCounter = newStability
            
            return true
        }
        
        return false
    }
    
    /// Updates hasExploded and currentColor
    private func stabilityChanged() {
        // alpha = 0.0 should be white, alpha = 1.0 should be red
        if (self.stabilityCounter < 0.0) {
            self.hasExploded = true
        }
        
        // begins with 0.0, ends with 1.0
        let progressPercentage = self.stabilityCounter/self.stabilityLimit
                
        if (progressPercentage >= 0.0 && progressPercentage <= 1.0) {
            let newRed = CGFloat(255/255)
            let newGreen = CGFloat(progressPercentage)
            let newBlue = CGFloat(progressPercentage)
            
            self.currentColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
    }
}
