//
//  CATExtensionTests.swift
//  Dome
//
//  Created by lbencs on 8/4/16.
//  Copyright © 2016 lben. All rights reserved.
//

import XCTest
import ObjectiveC
import CoreFoundation
@testable import Dome


class CATExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testAllPropertyNames() {
        XCTAssertNotNil(UIView.at_allPropertyNames())
    }
    func testAllIvarNames() {
        XCTAssertNotNil(UIView.at_allIvarNames())
    }

    func testEncode() {
        
        let model: CATEncodeTestModel = CATEncodeTestModel()
        
        model.propertyName = "lben";
        model.propertyCaches = ["1":"2"]
        model.propertyBool = true
        model.propertyInteger = 19
        model.propertyDouble = 1.00
        model.propertyFloat = 1.3
        
//        model .setValue(1, forKey: "propertyInteger")
    
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        let filePath = path?.stringByAppendingString("user.lben")
        
        NSKeyedArchiver.archiveRootObject(model, toFile: filePath!)
        
        let m: CATEncodeTestModel = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath!) as! CATEncodeTestModel

        XCTAssertTrue(m.propertyName == "lben" && (model.propertyCaches["1"] as! String) == "2")

    }
    
    func testModelToObjc() {
        
        let model: CATEncodeTestModel = CATEncodeTestModel()
        model.propertyName = "lben";
        model.propertyCaches = ["1":"2"]
        model.propertyBool = true
        model.propertyInteger = 19
        model.propertyDouble = 1.00
        model.propertyFloat = 1.3
        model.model = model.copy() as? CATEncodeTestModel
        model.modelArray = [(model.copy() as? CATEncodeTestModel)!, (model.copy() as? CATEncodeTestModel)!]
        
        let dic = model.at_modelToJSONObjc()
        
        print(dic)
    }
    func testObjcToModel() {
        let json:[String: AnyObject] = [
            "ivarName" : "sun",
            "model" : "<null>",
            "modelArray" : "<null>",
            "propertyBool" :  1,
            "propertyCaches" : [
                "1" : 2,
            ],
            "propertyDouble" : 1,
            "propertyFloat" : 1.3,
            "propertyInteger" : 0,
            "propertyName" : "lben",
        ];
        let mode: CATEncodeTestModel = CATEncodeTestModel.at_JSONObjcToModel(json) as! CATEncodeTestModel
        print(mode)
    }
    
    func testModelIvarDetail() {
        let model: CATEncodeTestModel = CATEncodeTestModel()
        model.propertyName = "lben";
        model.propertyCaches = ["1":"2"]
        model.propertyBool = true
        model.propertyInteger = 19
        model.propertyDouble = 1.00
        model.propertyFloat = 1.3
        model.model = model.copy() as? CATEncodeTestModel
        model.modelArray = [(model.copy() as? CATEncodeTestModel)!, (model.copy() as? CATEncodeTestModel)!]
//        model.ivarList()
        print(CATRuntimer().ivarList(CATEncodeTestModel.classForCoder()))
    }
}
