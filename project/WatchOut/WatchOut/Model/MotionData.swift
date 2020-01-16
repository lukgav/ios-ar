//
//  MotionData.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class MotionData {
    var attitude: SIMD3<Double>
    var rotationRate: SIMD3<Double>
    var acceleration: SIMD3<Double>
    var gravity: SIMD3<Double>
    
    init(attitude: SIMD3<Double> = SIMD3<Double>(0,0,0), rotationRate: SIMD3<Double> = SIMD3<Double>(0,0,0),
         gravity: SIMD3<Double> = SIMD3<Double>(0,0,0), acceleration: SIMD3<Double> = SIMD3<Double>(0,0,0)) {
        self.attitude = attitude
        self.rotationRate = rotationRate
        self.gravity = gravity
        self.acceleration = acceleration
    }
    
    func diff(other: MotionData) -> MotionData {
        return MotionData(attitude: self.attitude - other.attitude,
                          rotationRate: self.rotationRate - other.rotationRate,
                          gravity: self.gravity - other.gravity,
                          acceleration: self.acceleration - other.acceleration)
    }
    
    func ToString() -> String {
        let attX = String(format: "%.001f", attitude.x)
        let attY = String(format: "%.001f", attitude.y)
        let attZ = String(format: "%.001f", attitude.z)
        let rotRateX = String(format: "%.001f", rotationRate.x)
        let rotRateY = String(format: "%.001f", rotationRate.y)
        let rotRateZ = String(format: "%.001f", rotationRate.z)
        let gravX = String(format: "%.001f", gravity.x)
        let gravY = String(format: "%.001f", gravity.y)
        let gravZ = String(format: "%.001f", gravity.z)
        let accX = String(format: "%.001f", acceleration.x)
        let accY = String(format: "%.001f", acceleration.y)
        let accZ = String(format: "%.001f", acceleration.z)
        
        return String("Att: \(attX),\(attY),\(attZ), Rot: \(rotRateX),\(rotRateY),\(rotRateZ), Grav: \(gravX),\(gravY),\(gravZ), Att: \(accX),\(accY),\(accZ)")
    }
}

class MotionDataObserver : ObserverProtocol {
    var id: Int = 1
    
    func onValueChanged(_ value: Any?) {
        print("OnValueChanged \(value)" )
    }
}
