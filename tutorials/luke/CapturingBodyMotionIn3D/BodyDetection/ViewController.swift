/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    
//    var cards = [Entity] = []
//    var characters = [BodyTrackedEntity] = []
    
    var character: BodyTrackedEntity?
    // The 3D character to display.
//    var character: BodyTrackedEntity?
    let numOfCharacters = 4
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    
    var characterB: BodyTrackedEntity?
    let characterOffsetB: SIMD3<Float> = [1.0, 0, 0]
    
    let characterAnchor = AnchorEntity()
    let characterAnchorB = AnchorEntity()
    let characterAnchorC = AnchorEntity()
    let characterAnchorD = AnchorEntity()

    
    var characters: Array<BodyTrackedEntity> = []
    var characterOffsets: Array<SIMD3<Float>> = []
    var characterAnchors: Array<AnchorEntity> = []
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        characterAnchors = Array(repeating: AnchorEntity(), count: self.numOfCharacters)
        characterOffsets = Array(repeating: [1.0, 0, 0], count: self.numOfCharacters)
        
        for  i in 0...self.numOfCharacters-1{
            characterAnchors[i] = AnchorEntity()
            arView.scene.addAnchor(characterAnchors[i])
        }
        
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
            },
            receiveValue: { (character: Entity) in
                if let character = character as? BodyTrackedEntity {
                    character.scale = [1.0, 1.0, 1.0]
                    self.characters = Array(repeating: character.clone(recursive: true), count: self.numOfCharacters)

                    for  i in 0...self.numOfCharacters - 1{
                        let x : Float = Float(i % 4) + 0.25
                        let z : Float = Float(i / 4) + 0.25
                        self.characters[i] = character.clone(recursive: true)
                        self.characterOffsets[i] = [x, 0, z]
                    }

                    cancellable?.cancel()
                } else {
                    print("Error: Unable to load model as BodyTrackedEntity")
                }
            }
        )
    }
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)

            for  i in 0...self.numOfCharacters - 1{
                characterAnchors[i].position = bodyPosition + characterOffsets[i]
                characterAnchors[i].orientation = Transform(matrix: bodyAnchor.transform).rotation

                
                if characters[i].parent == nil {

                    characterAnchors[i].addChild(characters[i])
                    
                }
            }
        }
    }
}
