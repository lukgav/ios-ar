//
//  ViewController.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 08.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import UIKit
import CoreMotion


struct Vector3D {
    var x: Double? = 0.0
    var y: Double? = 0.0
    var z: Double? = 0.0
    var defaultStr: String = "pos"
//    var displayString: String ="x: \(self.x!), y: \(self.pos.y!), z: \(self.pos.z!) \n "

}

enum UnitVector {
    case position
    case acceleration
    case velocity
    case jerk
}




class ViewController: UIViewController {
    
    let motion = CMMotionManager()

    var pos = Vector3D()
    var acc = Vector3D()
    var maxAcc = Vector3D()
    var vectorChosen: UnitVector? = .position




    @IBOutlet var gyroView: UITextView!
        
    
    func roundFloat(p: Double) -> Double {
        let y = Double(round(1000*p)/1000)
        print(y)  // 1.236
        return y
    }
    
    func setMotion3DVector(unit: UnitVector) -> Vector3D{
        var vector = Vector3D()
        switch unit{
        case .position:
            print("position")
            if let data = self.motion.deviceMotion {
                vector.x = self.roundFloat(p: data.attitude.pitch);
                vector.y = self.roundFloat(p: data.attitude.roll)
                vector.z = self.roundFloat(p: data.attitude.yaw)
            }
            self.pos = vector
        case .acceleration:
            print("acceleration")
            if let data = self.motion.deviceMotion {
               vector.x = self.roundFloat(p: data.userAcceleration.x)
               vector.y = self.roundFloat(p: data.userAcceleration.y)
               vector.z = self.roundFloat(p: data.userAcceleration.z)
           }
            self.acc = vector
        case .velocity:
            print("velocity")
        case .jerk:
            print("jerk")
        }
        
        return vector
    }
    
    func updateMaxAcc(){
        if self.acc.x! > self.maxAcc.x!{
           self.maxAcc.x! = self.acc.x!
       }
       if self.acc.x! > self.maxAcc.y!{
           self.maxAcc.y! = self.acc.y!
       }
       if self.acc.x! > self.maxAcc.z!{
           self.maxAcc.z! = self.acc.z!
       }
    }
    
    
    
    func startDeviceMotion() {
        
        self.pos.x = 5

        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 30.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            let timer = Timer(fire: Date(), interval: (1.0 / 30.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    
//                                    pos.z
                                    // Get the attitude relative to the magnetic north reference frame.
                                    self.vectorChosen = .position
                                    self.setMotion3DVector(unit: self.vectorChosen!)
                                    
                                    self.vectorChosen = .acceleration
                                    self.setMotion3DVector(unit: self.vectorChosen!)
                                                                     
                                    
//                                    self.pos.x = self.roundFloat(p: data.attitude.pitch);
//                                    self.pos.y = self.roundFloat(p: data.attitude.roll)
//                                    self.pos.z = self.roundFloat(p: data.attitude.yaw)
//                                    var pos = [x, y, z]
                                    
                                    self.acc.x = self.roundFloat(p: data.userAcceleration.x)
                                    self.acc.y = self.roundFloat(p: data.userAcceleration.y)
                                    self.acc.z = self.roundFloat(p: data.userAcceleration.z)
                                    
                                    self.updateMaxAcc()
  
                                    let posString = "x: \(self.pos.x!), y: \(self.pos.y!), z: \(self.pos.z!) \n "
                                    let accString = "aX: \(self.acc.x!), \n aY: \( self.acc.y!),\n  aZ: \(self.acc.z!) \n"
                                    let maxAccString = "\n maxX: \(self.maxAcc.x!) \n maxY: \(self.maxAcc.y!) \n maxZ: \(self.maxAcc.z!) \n"
                                    
                                    self.gyroView.text = posString + accString + maxAccString
                                    
//                                    self.gyroView.text = "x: \(self.pos.x!), y: \(self.pos.y!), z: \(self.pos.z!) \n aX: \( accX), \n aY: \( accY),\n  aZ: \(accZ) \n \n maxX: \(self.maxAcc.x!) \n maxY: \(self.maxAcc.y!) \n maxZ: \(self.maxAcc.z!)"
                                    
                                    
//                                    self.gyroView.text = "x: \(x), y: \(y) z: \( z) \n aX: \( accX), \n aY: \( accY),\n  aZ: \(accZ) \n \n maxX: \(self.maxX) \n maxY: \(self.maxY) \n maxZ: \(self.maxZ)"
                                    
                                    // Use the motion data in your app.
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
            
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()
        // Do any additional setup after loading the view.
    }


}

