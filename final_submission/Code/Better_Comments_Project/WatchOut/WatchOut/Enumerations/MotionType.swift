//
//  MotionType.swift
//  WatchOut
//
//  Created by Luke Gavin on 17.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import Foundation

enum MotionType {
    case attitude
    case acceleration
    case gravity
    case rotation
    
    var toString : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .attitude: return "attitude"
        case .acceleration: return "acceleration"
        case .gravity: return "gravity"
        case .rotation: return "rotation"
        }
     }
}
