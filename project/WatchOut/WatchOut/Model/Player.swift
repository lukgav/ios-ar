//
//  Player.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class Player {
   
    var name: String?
    var id: Int?
    var limit: Double?
    var isLoser: Bool?
    
    init(name: String, id: Int, limit: Double, isLoser: Bool) {
        self.name = name
        self.id = id
        self.limit = limit
        self.isLoser = isLoser
    }
    
    func decreaseLimit(decreaseAmount: Double) -> Bool {
        if (self.limit! - decreaseAmount > 0.0) {
            self.limit! -= decreaseAmount
            return true
        } else {
            return false
        }
    }
    
    
    
}
