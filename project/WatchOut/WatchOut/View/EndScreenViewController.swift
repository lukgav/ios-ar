//
//  EndScreenViewController.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class EndScreenViewController: UIViewController {

    var controller : EndScreenController?
    
    let gameManager = GameManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller = EndScreenController(endScreenController: self, gameManager: gameManager)
        
        loserName.text = self.gameManager.loserPlayer!.name
    
    }
    
    @IBAction func BackToHomeButtonTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    
    
    @IBOutlet weak var loserName: UILabel!
    
}
