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
            stabilityChangedClosure?()
            print("StabilityCounter changed from \(oldValue) to \(stabilityCounter)")
        }
    }
    
    var stabilityChangedClosure: (()->())?
    
    var decreaseOverTime: Bool
    
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
    }
}
