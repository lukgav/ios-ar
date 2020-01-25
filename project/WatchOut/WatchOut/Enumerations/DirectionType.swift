//
//  DirectionType.swift
//  WatchOut
//
//  Created by Luke Gavin on 17.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import Foundation

enum Direction {
    case x
    case y
    case z
    
    var toString : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .x: return "X-Dir"
        case .y: return "Y-Dir"
        case .z: return "Z-Dir"
        }
     }
    
}
