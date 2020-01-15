//
//  Task.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 13.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation
import UIKit


class GeneralTask{
    var _sensor: NSObject
    
    init (pSensor: NSObject){
        self._sensor = pSensor
    }
    
    func UpdateData(){
        fatalError("Must Override")
    }
    
    func BackupData(){
        fatalError("Must Override")
    }
    
}
