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
    
    var instanceOfCustomObject: CustomObject = CustomObject()
    
//    TestObjectiveCClass.printHello()
    
//    var test : CustomObject
//    test = CustomObject()
//    test.someProperty
//    instanceOfCustomObject.someProperty = "Hello"
//    println(instanceOfCustomObject.someProperty)
//    instanceOfCustomObject.someMethod()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.text = "Test me baby"
        // Do any additional setup after loading the view.
    }


}

