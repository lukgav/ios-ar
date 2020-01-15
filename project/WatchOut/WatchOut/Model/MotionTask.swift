//
//  MotionTask.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 13.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation
//import Task
import CoreMotion

class MotionTask: GeneralTask{
        
    var vector: SIMD3<Double>?
    
    init(){
        let motionManager = CMMotionManager()
        vector = SIMD3<Double>()
        super.init(pSensor: motionManager)
     }
    
    func showData(pCoOrds: SIMD3<Double>) -> String{
        var displayString: String = "x: \(pCoOrds.x), y: \(pCoOrds.y), z: \(pCoOrds.z) \n "
        return displayString
    }
    
    func ExecuteMotion(){
        
    }
    
    override func UpdateData(){
        
    }
    
    override func BackupData(){
        
    }
    
}
