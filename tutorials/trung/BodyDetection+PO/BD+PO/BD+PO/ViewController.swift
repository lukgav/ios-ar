//
//  ViewController.swift
//  BD+PO
//
//  Created by iOS1920 on 29.11.19.
//  Copyright © 2019 iOS1920. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController {

    @IBOutlet var arView: ARView!
    @IBOutlet var messageLabel: RoundedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let vase = try ModelEntity.load(named: "vase")
            
            // Place model on a horizontal plane.
            let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
            arView.scene.anchors.append(anchor)
            
            vase.scale = [1, 1, 1] * 0.006
            anchor.children.append(vase)
        } catch {
            fatalError("Failed to load asset.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.togglePeopleOcclusion()
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        togglePeopleOcclusion()
    }
    
    fileprivate func togglePeopleOcclusion() {
        guard let config = arView.session.configuration as? ARWorldTrackingConfiguration else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        switch config.frameSemantics {
        case [.personSegmentationWithDepth]:
            config.frameSemantics.remove(.personSegmentationWithDepth)
            messageLabel.displayMessage("People occlusion off", duration: 1.0)
        default:
            config.frameSemantics.insert(.personSegmentationWithDepth)
            messageLabel.displayMessage("People occlusion on", duration: 1.0)
        }
        arView.session.run(config)
    }
}

