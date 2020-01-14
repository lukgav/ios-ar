//
//  DeviceMotionManager.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import CoreMotion

class DeviceMotionManager {

    static let shared = DeviceMotionManager()
    private let motion: CMMotionManager
    private var timer: Timer
    
    @Published var motionData: MotionData
    
    var updateInterval: Double = 1.0/60
    
    private init(){
        motion = CMMotionManager()
        motionData = MotionData(attitude: SIMD3<Double>(0.0,0.0,0.0),
                                acceleration: SIMD3<Double>(0.0,0.0,0.0),
                                gravity: SIMD3<Double>(0.0,0.0,0.0))
        timer = Timer()
    }
    
    func startDeviceMotion() -> Bool {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = updateInterval
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    // Get the attitude relative to the magnetic north reference frame.
                                    
                                    let attitude = SIMD3<Double>(data.attitude.pitch,
                                                                 data.attitude.roll,
                                                                 data.attitude.yaw)
                                    
                                    let acceleration = SIMD3<Double>(data.userAcceleration.x,
                                                                     data.userAcceleration.y,
                                                                     data.userAcceleration.z)
                                    
                                    let gravity = SIMD3<Double>(data.gravity.x,
                                                                data.gravity.y,
                                                                data.gravity.z)
                                    
                                    self.motionData = MotionData(attitude: attitude,
                                                            acceleration: acceleration,
                                                            gravity: gravity)
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
            
            return true
        }
        else {
            return false
        }
    }
    
    func stopDeviceMotion() -> Bool {
        if motion.isDeviceMotionActive {
            motion.stopDeviceMotionUpdates()
            motion.showsDeviceMovementDisplay = false
            
            timer.invalidate()
            
            return true
        }
        else {
            return false
        }
    }
}
