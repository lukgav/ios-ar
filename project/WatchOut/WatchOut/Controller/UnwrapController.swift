//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class UnwrapController {
 
    let dmManager = DeviceMotionManager.shared
    let observer = MotionDataObserver()
        
    func startTest() {
        dmManager.startDeviceMotion()
        dmManager.currentMotionData.addObserver(observer) { newData in
            print("Gravity")
            print(newData.gravity)
        }
    }
        
    func stopTest() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
        dmManager.stopDeviceMotion()
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
