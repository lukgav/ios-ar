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
    // max stability at start
    let stabilityLimit: Double
    // current stability
    var stabilityCounter: Double {
        didSet {
            // closure is executed everytime a new value did set
            stabilityChangedClosure?()
        }
    }
    
    var stabilityChangedClosure: (()->())?
    
    var decreaseOverTime: Bool
    
    var hasExploded: Bool = false
    
    // timer
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
    
    func checkStability()->Bool{
        if (stabilityCounter < 0.0) {
            print("BOOOOOOOOOOOOOOM")
            return true
        }
        else if(stabilityCounter == 0.5){
            print("I don't feel so good")
            return false
        }
        else if(stabilityCounter == 0.25){
            print("Is it hot in here? I'm boiling")
            return false
        }
        else if(stabilityCounter == 0.1){
            print("Tell my kids I love them")
            return false
        }
        else if(stabilityCounter == 0.05){
            print("...")
            return false
        }
        return false
    }
}
