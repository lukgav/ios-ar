//
//  UnwrapViewController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class UnwrapViewController: UIViewController {

    var controller: UnwrapController?

//    @IBOutlet weak var currentPlayer: UILabel!
    @IBOutlet var currentPlayer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        controller = UnwrapController(unwrapViewController: self)
        
        controller?.startUnwrapAroundZ()
        
        //curPlayer.text = String(currentP)
    }
    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    
    @IBAction func NextTaskTouch(_ sender: Any) {
        controller?.navigateToNextTask()
    }
    
    func updateBackgroundColor(pColor: UIColor) {
        self.view.backgroundColor = pColor
    }
    func updatePlayerNameLabel(name: String) {
        currentPlayer.text = name
    }
    
}
