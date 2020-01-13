//
//  bombManager.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 13.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation
import UIKit

class BombManager{
    let maxStability: Int = 100
    var stability: Int
    var degradation: Int
    var degradationRate: Int
    
    var colorStability: CGFloat
    var colorDanger: CGFloat
    
    var timer: Timer
    var warning: UIColor
    
    init(){
        self.degradationRate = 1
        self.stability = self.maxStability
        self.degradation = 0
        self.timer = Timer.init()
        self.colorDanger = CGFloat((self.degradation/self.maxStability) * 255)
        self.colorStability = CGFloat((self.stability/self.maxStability) * 255)
        self.warning = UIColor(red: self.colorDanger, green: self.colorStability, blue: 1, alpha: 1)
    }
    
    func updateColorWarning(pNum: Int){
        var newStability: Int = self.stability - pNum
        var newDegradation: Int = self.degradation + pNum

        self.colorStability = CGFloat((newStability/self.maxStability) * 255)
        self.colorDanger = CGFloat((newDegradation/self.maxStability) * 255)
    }
    
    func TakeDamage(){
        updateColorWarning(pNum: self.degradationRate)
    }
    
    func IncreaseStability(){
        let addStability: Int = -3
        updateColorWarning(pNum: addStability)
    }
    
    func IncreaseDegradationRateBy(pNum: Int){
        self.degradationRate = self.degradationRate + pNum
    }
    
    func IncreaseDegradationRate(){
        let increaseRate: Int = 1
        IncreaseDegradationRateBy(pNum: increaseRate)
    }
    
}
