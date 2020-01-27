//
//  ViewController.swift
//  LightAmbientSensor_Test
//
//  Created by Luke Gavin on 16.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var testView: UITextView!
    
    var instanceofLightSensor: LightAmbienceDataObject = LightAmbientSensor()

    
    func testLightObject(){
        instanceofLightSensor.printHello
        instanceofLightSensor.sayHello()
    }
    
//    CustomObject.printHello()
    
//    var test : CustomObject
//    test = CustomObject()
//    instanceOfCustomObject.someProperty = "Test"
//    instanceOfCustomObject.someProperty = "Hello"

    func testCustomObject(){
        instanceOfCustomObject.someMethod()
        instanceOfCustomObject.someProperty = "Test"
        print(instanceOfCustomObject.someProperty!)
        instanceOfCustomObject.someMethod()
    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomObject.printHello()
        testCustomObject()
        
        testView.text = CustomObject.sayHello()
        // Do any additional setup after loading the view.
    }


}

