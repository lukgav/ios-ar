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
        // change color everytime stabiltyCounter value changed
        didSet {
            updateCurrentColor()
        }
    }
    
    var decreaseOverTime: Bool
    
    var explosionColor: UIColor
    var currentColor: UIColor
    
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
        explosionColor = UIColor.black
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
            self.currentTime += 1.0/50.0
        }
    }
    
    /// Returns false, if the bomb exlodes after decreasing the stability
    func decreaseStability(decreaseAmount: Double) -> Bool{
        if (self.stabilityCounter - decreaseAmount > 0.0) {
            self.stabilityCounter -= decreaseAmount
            return true
        }
        else
        {
            return false
        }
    }
    
    /// Returns false, if the bomb exlodes after decreasing the stability
    func decreaseStability(percentage: Double) -> Bool{
        let decreaseAmount = percentage/100.0*stabilityLimit
        return decreaseStability(decreaseAmount: decreaseAmount)
    }
    
    /// Returns false, if the bomb explodes when setting the new percentage (>100%)
    func setStability(percentage: Double) -> Bool {
        let newStability = percentage/100.0*stabilityLimit
        self.stabilityCounter = newStability
        if (newStability > stabilityLimit) {
            return false
        }
        else {
            return true
        }
    }
    
    func increaseStability(increaseAmount: Double){
        // only increase to a maximum of the stabilyLimit
        if(self.stabilityCounter + increaseAmount >= stabilityLimit) {
            self.stabilityCounter = stabilityLimit
        }
        else {
            self.stabilityCounter += increaseAmount
        }
    }
    
    func increaseStability(percentage: Double){
        let increaseAmount = percentage/100.0*stabilityLimit
        return increaseStability(increaseAmount: increaseAmount)
    }
    
    private func updateCurrentColor() {
        // alpha = 0.0 is white, alpha = 1.0 is black
        let percentage = CGFloat(1.0 - self.stabilityCounter/self.stabilityLimit)
        self.currentColor = UIColor(red: 1, green: 0, blue: 0, alpha: percentage)
    }
}
