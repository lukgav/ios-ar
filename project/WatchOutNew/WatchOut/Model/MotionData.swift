//
//  MotionData.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import Combine

class MotionData: ObservableObject{
    @Published var attitude: SIMD3<Double>
    @Published var acceleration: SIMD3<Double>
    @Published var gravity: SIMD3<Double>
    
    init(attitude: SIMD3<Double>, acceleration: SIMD3<Double>, gravity: SIMD3<Double>) {
        self.attitude = attitude
        self.acceleration = acceleration
        self.gravity = gravity
    }
}
