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
    
    //Rotation Code (to check max value)
    func rotationContainsHigherAbsoluteValue(than: Double) -> Bool {
        return rotationContainsHigherAbsoluteValueinXYZDirection(maxX: than, maxY: than, maxZ: than)
    }

    func rotationContainsHigherAbsoluteValueinXYZDirection(maxX: Double, maxY: Double, maxZ: Double) -> Bool {
        let rotation = MotionType.rotation
        return (PassedMaxXValueOf(motionType: rotation, maxValue: maxX) || PassedMaxYValueOf(motionType: rotation, maxValue: maxY)  || PassedMaxZValueOf(motionType: rotation, maxValue: maxZ))
    }
    
    //Acceleration Code(to check max value)
    func accelerationContainsHigherAbsoluteValue(than: Double) -> Bool {
        return rotationContainsHigherAbsoluteValueinXYZDirection(maxX: than, maxY: than, maxZ: than)

    }
    func accelerationContainsHigherAbsoluteValueXYZDirection(maxX: Double, maxY: Double, maxZ: Double) -> Bool {
        let acceleration = MotionType.acceleration
        return(PassedMaxXValueOf(motionType: acceleration, maxValue: maxX) || PassedMaxYValueOf(motionType: acceleration, maxValue: maxY) || PassedMaxZValueOf(motionType: acceleration, maxValue: maxZ) )
    }
    
    //Gravity Code(to check max value)
    func gravityContainsHigherAbsoluteValue(than: Double) -> Bool {
        return gravityContainsHigherAbsoluteValueXYZDirection(maxX: than, maxY: than, maxZ: than)
    }
    func gravityContainsHigherAbsoluteValueXYZDirection(maxX: Double, maxY: Double, maxZ: Double) -> Bool {
        let gravity = MotionType.gravity
        return(PassedMaxXValueOf(motionType: gravity, maxValue: maxX) || PassedMaxYValueOf(motionType: gravity, maxValue: maxY) || PassedMaxZValueOf(motionType: gravity, maxValue: maxZ) )
    }
    
    
    
    //Chose MotionType and direction
    func PassedMaxXValueOf(motionType: MotionType, maxValue: Double) -> Bool {
        switch motionType{
        case MotionType.attitude:
            return (abs(rotationRate.x) > maxValue)
        case MotionType.acceleration:
            return (abs(acceleration.x) > maxValue)
        case MotionType.gravity:
            return (abs(gravity.x) > maxValue)
        case MotionType.rotation:
            return (abs(rotationRate.x) > maxValue)
        }
    }
    
    func PassedMaxYValueOf(motionType: MotionType, maxValue: Double) -> Bool {
        switch motionType{
        case MotionType.attitude:
            return (abs(rotationRate.y) > maxValue)
        case MotionType.acceleration:
            return (abs(acceleration.y) > maxValue)
        case MotionType.gravity:
            return (abs(gravity.y) > maxValue)
        case MotionType.rotation:
            return (abs(rotationRate.y) > maxValue)
        }
    }
    
    func PassedMaxZValueOf(motionType: MotionType, maxValue: Double) -> Bool {
        switch motionType{
        case MotionType.attitude:
            return (abs(rotationRate.z) > maxValue)
        case MotionType.acceleration:
            return (abs(acceleration.z) > maxValue)
        case MotionType.gravity:
            return (abs(gravity.z) > maxValue)
        case MotionType.rotation:
            return (abs(rotationRate.z) > maxValue)
        }
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
