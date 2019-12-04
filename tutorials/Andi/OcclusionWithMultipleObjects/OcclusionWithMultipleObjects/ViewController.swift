//
//  ViewController.swift
//  OcclusionWithMultipleObjects
//
//  Created by iOS1920 on 04.12.19.
//  Copyright © 2019 iOS1920. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        // Enable Debug Options
        arView.debugOptions = [ARView.DebugOptions.showFeaturePoints,
                               ARView.DebugOptions.showWorldOrigin,
                               ARView.DebugOptions.showAnchorOrigins]
        
        arView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addObjectToSceneView))
        arView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func toggleOcclusion(isOn: Bool) {
        guard let config = arView.session.configuration as? ARWorldTrackingConfiguration
            else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
    
        if isOn {
            // Enable People Occlusion
            guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth)
                else {
                fatalError("People occlusion is not supported on this device.")
            }
            
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        else {
            config.frameSemantics.remove(.personSegmentationWithDepth)
        }
        
        arView.session.run(config)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        toggleOcclusion(isOn: sender.isOn)
    }
    
    @objc func addObjectToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        guard let raycastQuery = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else {
            fatalError("Could not make RaycastQuery")
        }
        
        guard let result = arView.session.raycast(raycastQuery).first else {
            print("No raycast results")
            return
        }
                       
        let rayCastAnchor = AnchorEntity(raycastResult: result)
        arView.scene.anchors.append(rayCastAnchor)
        
        do {
            let vase = try ModelEntity.load(named: "vase")
            vase.scale = [1, 1, 1] * 0.02
            rayCastAnchor.children.append(vase)
        } catch {
            fatalError("Failed to load asset.")
        }
    }
}
