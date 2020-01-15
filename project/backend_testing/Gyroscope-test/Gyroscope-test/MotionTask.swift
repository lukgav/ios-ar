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
    
    func VectorToString(pVec: SIMD3<Double>, pName: String) -> String{
        var displayString: String = "\(pName)x: \(pVec.x), \(pName)y: \(pVec.y), \(pName)z: \(pVec.z) \n "
        return displayString
    }
    
    func ExecuteMotion(){
        
    }
    
    override func PrintDatatoDevice(){
         let accString = self.VectorToString(pVec: self.vector!, pName: "vector")
         print(accString)
         
     }
    override func UpdateData(){
        
    }
    
    override func BackupData(){
        
    }
    
}
