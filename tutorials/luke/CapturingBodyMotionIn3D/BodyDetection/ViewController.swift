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
    let numOfCharacters = 2
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
 
    
    //New Code
//    let characterOffsetB: SIMD3<Float> = [1.0, 0, 0] // Offset the character by one meter to the left

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
        characterAnchors = Array(repeating: AnchorEntity(), count: self.numOfCharacters)

//        characterAnchors = [characterAnchor, characterAnchorB, characterAnchorC, characterAnchorD]

//
//        var numChars = self.numOfCharacters
//        var numanchors = characterAnchors.count
//
        for  i in 0...self.numOfCharacters-1{
            arView.scene.addAnchor(characterAnchors[i])
        }
        
//        arView.scene.addAnchor(characterAnchor)
//        //New Code
//        arView.scene.addAnchor(characterAnchorB)
        
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

//                    self.character = character
//                    self.character = character.clone(recursive: true)

                    self.characters = Array(repeating: character.clone(recursive: true), count: self.numOfCharacters)
                    self.characterOffsets = Array(repeating: [1.0, 0, 0], count: self.numOfCharacters)
                    
                    for  i in 0...self.numOfCharacters - 1{
                        
                        let x : Float = Float(i)
//                        self.characters[i] = character.clone(recursive: true)
//                        self.characterAnchors[i] = AnchorEntity()
                        self.characterOffsets[i] = [x*2 + -1.0, 0, 0]
                    }
                    
//                    let anchorArray = self.characterAnchors.count
//                    let offsetArray = self.characterOffsets.count
//                    let characterArray = self.characters.count

                    
                    
                    
//                    self.character = character
//                    self.characterB = character.clone(recursive: true)
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
//            characterOffsets = [self.characterOffset, self.characterOffsetB]

//            characterAnchor.position = bodyPosition + characterOffset
//            characterAnchorB.position = bodyPosition + characterOffsetB
//
//            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
//            characterAnchorB.orientation = Transform(matrix: bodyAnchor.transform).rotation
//
            
//            for offset in self.characterOffsets{
//                characterAnchor.position = bodyPosition + offset
//                characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
//            }
            for  i in 0...self.numOfCharacters - 1{
                characterAnchors[i].position = bodyPosition + characterOffsets[i]
                characterAnchors[i].orientation = Transform(matrix: bodyAnchor.transform).rotation

                
//                if characters[i].parent == nil {
//                    characterAnchors[i].addChild(characters[i])
////                        characterAnchor.addChild(self.characterB)
//                }
            }
            
            if characters[0].parent == nil {
                    characterAnchors[0].addChild(characters[0])
            }
            if characters[1].parent == nil {
                    characterAnchors[1].addChild(characters[1])
                
            }
            
//            for char in self.characters{
//                if let character = character, character?.parent == nil {
//                        characterAnchor.addChild(character!)
//    //                    characterAnchor.addChild(self.characterB)
//                    }
//            }
//
////            for char in self.characters{
//            if character == characterB, character?.parent == nil {
//                    characterAnchorB.addChild(characterB!)
//    //                characterAnchor.addChild(self.characterB)
//                }
//            }
            
//            if let character = character, character.parent == nil {
//                characterAnchor.addChild(character)
////                characterAnchor.addChild(self.characterB)
//            }
//            if let characterX = characterB {
//                characterAnchorB.addChild(characterX)
////                characterAnchor.addChild(self.characterB)
//            }
        }
    }
}

//if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices {
//      captureDevice = availableDevices.first
//      beginSession()
//  }
//
//if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
//    captureDevice = availableDevice
//    beginSession()
//}
