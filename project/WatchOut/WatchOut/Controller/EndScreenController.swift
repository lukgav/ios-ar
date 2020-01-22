//
//  EndScreenController.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class EndScreenController {

    private let endScreenViewController : EndScreenViewController
    
    private let gameManager = GameManager.shared
    
    init(endScreenViewController: EndScreenViewController) {
        self.endScreenViewController = endScreenViewController
    }
        
    // MARK: - Navigation
    
    func navigateToHome() {
        endScreenViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
    }
}
