//
//  MotionData.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class MotionData {
    var attitude: SIMD3<Double> // pitch, roll, yaw
    var rotationRate: SIMD3<Double> // rotation in x,y,z
    var acceleration: SIMD3<Double> // acceleration in x,y,z
    var gravity: SIMD3<Double> // gravity (depends on earths magnetic field)
    
    init(attitude: SIMD3<Double> = SIMD3<Double>(0,0,0), rotationRate: SIMD3<Double> = SIMD3<Double>(0,0,0),
         gravity: SIMD3<Double> = SIMD3<Double>(0,0,0), acceleration: SIMD3<Double> = SIMD3<Double>(0,0,0)) {
        self.attitude = attitude
        self.rotationRate = rotationRate
        self.gravity = gravity
        self.acceleration = acceleration
    }
    
    // helper function to calculate the difference of two MotionData objects
    func diff(other: MotionData) -> MotionData {
        return MotionData(attitude: self.attitude - other.attitude,
                          rotationRate: self.rotationRate - other.rotationRate,
                          gravity: self.gravity - other.gravity,
                          acceleration: self.acceleration - other.acceleration)
    }

    // helper for unwrap
    func isMotionOutOfRangeInDirection(pMotion: SIMD3<Double>, maxX: Double, maxY: Double, maxZ: Double, pMinValue: Double) -> Bool {
        return(
            isOutOfRangeInDirection(pMotion: pMotion, pDirection: Direction.x, maxValue: maxX, minValue: pMinValue) ||
            isOutOfRangeInDirection(pMotion: pMotion, pDirection: Direction.y, maxValue: maxX, minValue: pMinValue) ||
            isOutOfRangeInDirection(pMotion: pMotion, pDirection: Direction.z, maxValue: maxX, minValue: pMinValue)
        )
    }
    
    // helper for unwrap
    func isOutOfRangeInDirection(pMotion: SIMD3<Double>, pDirection: Direction, maxValue: Double, minValue: Double)-> Bool{
        switch pDirection{
        case .x:
            return (abs(pMotion.x) > maxValue || abs(pMotion.x) < minValue )
        case .y:
            return (abs(pMotion.y) > maxValue || abs(pMotion.y) < minValue )
        case .z:
            return (abs(pMotion.z) > maxValue || abs(pMotion.z) < minValue )
        }
    }

        
    // check rotation absolute values
    func rotationContainsHigherAbsoluteValue(than: Double) -> Bool {
        return isMotionGreaterThanAbsoluteValue(pMotion: self.rotationRate, maxValue: than)
        
    }
    
    // check acceleration absolute values
    func accelerationContainsHigherAbsoluteValue(than: Double) -> Bool {
        return isMotionGreaterThanAbsoluteValue(pMotion: self.acceleration, maxValue: than)
        
    }
    
    // Gravity Code(to check max value)
    func gravityContainsHigherAbsoluteValue(than: Double) -> Bool {
        return isMotionGreaterThanAbsoluteValue(pMotion: self.gravity, maxValue: than)
    }
    
    // General Motion(Could be any of teh four motion types listed in MotionData
    func isMotionGreaterThanAbsoluteValue(pMotion: SIMD3<Double>, maxValue: Double) -> Bool {
        return isMotionGreaterThanMaxInEveryDirection(pMotion: pMotion, maxX: maxValue, maxY: maxValue, maxZ: maxValue)
    }
    
    func isMotionGreaterThanMaxInEveryDirection(pMotion: SIMD3<Double>, maxX: Double, maxY: Double, maxZ: Double) -> Bool {
        return(
            isGreaterThanMaxInDirection(pMotion: pMotion, pDirection: .x, maxValue: maxX) ||
            isGreaterThanMaxInDirection(pMotion: pMotion, pDirection: .y, maxValue: maxX) ||
            isGreaterThanMaxInDirection(pMotion: pMotion, pDirection: .z, maxValue: maxX)
        )
    }
    
    func isGreaterThanMaxInDirection(pMotion: SIMD3<Double>, pDirection: Direction, maxValue: Double)-> Bool{
        switch pDirection{
            case .x:
                return (abs(pMotion.x) >= maxValue)
            case .y:
                return (abs(pMotion.y) >= maxValue)
            case .z:
                return (abs(pMotion.z) >= maxValue)
        }
    }
    
    // check ranges of Y
    func isOutOfYRangeOf(motionType: MotionType, maxValue: Double, minValue: Double) -> Bool {
        switch motionType{
        case MotionType.attitude:
            return (abs(rotationRate.y) > maxValue)
        case MotionType.acceleration:
            return (abs(acceleration.y) > maxValue)
        case MotionType.gravity:
            return (abs(gravity.y) > maxValue || abs(gravity.z) < minValue )
        case MotionType.rotation:
            return (abs(rotationRate.y) > maxValue)
        }
    }
    
    // unwrap
    func isOverMaxYValueOf(motionType: MotionType, maxValue: Double) -> Bool {
        //TODO: Change Default min value to work with all motionTypes(May have to use another switch statment within this...(Blech)
        let minValueNoCare: Double = self.gravity.y
        return isOutOfYRangeOf(motionType: motionType, maxValue: maxValue, minValue: minValueNoCare)
    }
    
    // unwrap        
    func isUnderMinYValueOf(motionType: MotionType, minValue: Double) -> Bool {
        //TODO: Change Default min value to work with all motionTypes(May have to use another switch statment within this...(Blech)
        let maxValueNoCare: Double = self.gravity.y
        return isOutOfYRangeOf(motionType: motionType, maxValue: maxValueNoCare, minValue: minValue)
    }
    
    // check ranges of Z
    func isOutOfZRangeOf(motionType: MotionType, maxValue: Double, minValue: Double) -> Bool {
        switch motionType{
        case MotionType.attitude:
            return (abs(rotationRate.z) > maxValue)
        case MotionType.acceleration:
            return (abs(acceleration.z) > maxValue)
        case MotionType.gravity:
            return (abs(gravity.z) > maxValue || abs(gravity.z) < minValue )
        case MotionType.rotation:
            return (abs(rotationRate.z) > maxValue)
        }
    }
        
    func isOverMaxZValueOf(motionType: MotionType, maxValue: Double) -> Bool {
        //TODO: Change Default min value to work with all motionTypes(May have to use another switch statment within this...(Blech)
        let minValueNoCare: Double = self.gravity.z
        return isOutOfZRangeOf(motionType: motionType, maxValue: maxValue, minValue: minValueNoCare)
    }
        
    func isUnderMinZValueOf(motionType: MotionType, minValue: Double) -> Bool {
        //TODO: Change Default min value to work with all motionTypes(May have to use another switch statment within this...(Blech)
        let maxValueNoCare: Double = self.gravity.y
        return isOutOfZRangeOf(motionType: motionType, maxValue: maxValueNoCare, minValue: minValue)
    }
    
    // String representation of MotionData
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

// observer for MotionData
class MotionDataObserver : ObserverProtocol {
    var id: Int = 1
    
    func onValueChanged(_ value: Any?) {
        print("OnValueChanged \(value)" )
    }
}


