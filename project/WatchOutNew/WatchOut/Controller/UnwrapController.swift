//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
import Combine

class UnwrapController: UIViewController {
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DeviceMotionManager.shared.startDeviceMotion()
        
        DeviceMotionManager.shared.motionData.objectWillChange.sink(receiveValue: {
                let gravity = DeviceMotionManager.shared.motionData.gravity
            
                print(gravity)
            })
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
