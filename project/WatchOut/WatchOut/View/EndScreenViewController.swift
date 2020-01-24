//
//  EndScreenViewController.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class EndScreenViewController: UIViewController {

    
    @IBOutlet weak var youLoseLabel: UILabel!
    
    var controller : EndScreenController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller = EndScreenController(endScreenViewController: self)
        
        controller?.showLoserPlayer()
    }
    
    func updateLoserLabel(newText: String) {
        youLoseLabel.text = newText
    }
        
    @IBAction func BackToHomeTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    @IBAction func StartNewGameTouch(_ sender: Any) {
        controller?.navigateToFirstTask()
    }
}
