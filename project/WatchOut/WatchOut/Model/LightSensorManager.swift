//
//  LightSensorManager.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

class LightSensorManager : NSObject, ARSessionDelegate {
    
    static let shared = LightSensorManager()
    private let session = ARSession()
    var isRunning: Bool
    
    // value will be 1000.0 for a normal lighten room
    var ambientIntensity: Observable<Double>
    
    private let faceConfig = ARFaceTrackingConfiguration()
    
    private override init() {
        isRunning = false
        ambientIntensity = Observable(value: 0.0)
        
        session.delegate = self
        
        // supportedVideoFormats-Array contains videoformats sorted from best first to worst last
        faceConfig.videoFormat = ARFaceTrackingConfiguration.supportedVideoFormats.last!
        faceConfig.isLightEstimationEnabled = true
    }
    
    func startLightSensor() -> Bool {
        if (!isRunning && ARFaceTrackingConfiguration.isSupported) {
            session.run(faceConfig)
            isRunning = true
            
            return true
        }
        return false
    }
    
    func stopLightSensor() -> Bool {
        if(isRunning) {
            session.pause()
            isRunning = false
            
            return true
        }
        return false
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        ambientIntensity = Observable(value: Double(frame.lightEstimate!.ambientIntensity))
    }
}

class AmbientIntensityObserver : ObserverProtocol {
    var id: Int = 2
    
    func onValueChanged(_ value: Any?) {
        print("OnValueChanged \(value)" )
    }
}
