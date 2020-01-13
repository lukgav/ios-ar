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
    
    struct CoOrds3D {
        var x: Double? = 0.0
        var y: Double? = 0.0
        var z: Double? = 0.0
    //    init(startingValue)
    //    var vector: Double? = sqrt(powerOfTwo(x) + powerOfTwo(y) + powerOfTwo(z))
    //    var displayString: String = "x: \(x), y: \(y), z: \(z) \n "
    }
    
    init(){
        let motionManager = CMMotionManager()
        super.init(pSensor: motionManager)
     }
    
    func showData(pCoOrds: CoOrds3D) -> String{
        var displayString: String = "x: \(pCoOrds.x), y: \(pCoOrds.y), z: \(pCoOrds.z) \n "
        return displayString
    }
    
    
    override func UpdateData(){
        
    }
    
    override func BackupData(){
        
    }
    
}
