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
    var characters: Array<BodyTrackedEntity>
    // The 3D character to display.
//    var character: BodyTrackedEntity?
    let numOfCharacters = 2
    let characterAnchor = AnchorEntity()

    
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterOffsetB: SIMD3<Float> = [1.0, 0, 0]
    var characterOffsets: Array<SIMD3<Float>> = [characterOffset, characterOffsetB]
    
    //New Code
    var characterB: BodyTrackedEntity?
//    let characterOffsetB: SIMD3<Float> = [1.0, 0, 0] // Offset the character by one meter to the left
    let characterAnchorB = AnchorEntity()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        //New Code
        arView.scene.addAnchor(characterAnchorB)
        
        // Asynchronously load the 3D character.
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
                    // Scale the character to human size
                    character.scale = [1.0, 1.0, 1.0]

                    self.characters = Array(repeating: self.character!, count: 2)

                    
                    for var char in self.characters{
                        char = character.clone(recursive: true)
                    }
//                    self.character = character
//                    self.characterB = character.clone(recursive: true)
                    cancellable?.cancel()
                } else {
                    print("Error: Unable to load model as BodyTrackedEntity")
                }
            }
        )
    }
    
//    init() {
//        self.characters = Array(repeating: self.character!, count: 2)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            var characterOffsets = [self.characterOffset, self.characterOffsetB]

            characterAnchor.position = bodyPosition + characterOffset
            characterAnchorB.position = bodyPosition + characterOffsetB

            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            characterAnchorB.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            
            for var char in self.characters{
                char = character.clone(recursive: true)
            }
            
            if let character = character, character.parent == nil {
                characterAnchor.addChild(character)
//                characterAnchor.addChild(self.characterB)
            }
            if let characterX = characterB {
                characterAnchorB.addChild(characterX)
//                characterAnchor.addChild(self.characterB)
            }
            
        }
    }
}
