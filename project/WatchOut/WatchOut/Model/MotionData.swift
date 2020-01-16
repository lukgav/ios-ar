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
    
    init(attitude: SIMD3<Double>, rotationRate: SIMD3<Double>, gravity: SIMD3<Double>, acceleration: SIMD3<Double>) {
        self.attitude = attitude
        self.rotationRate = rotationRate
        self.gravity = gravity
        self.acceleration = acceleration
    }
}

class MotionDataObserver : ObserverProtocol {
    var id: Int = 1
    
    func onValueChanged(_ value: Any?) {
        print("OnValueChanged \(value)" )
    }
}
