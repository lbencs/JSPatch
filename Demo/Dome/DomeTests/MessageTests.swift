//
//  MessageTests.swift
//  Dome
//
//  Created by lbencs on 8/2/16.
//  Copyright © 2016 lben. All rights reserved.
//

import XCTest
import ObjectiveC
import CoreFoundation
@testable import Dome

class MessageTests: XCTestCase {
    
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
    
    
    func testPerform() {
        XCTAssertNotNil(NSObject().at_performSelector(#selector(NSObject.at_testPerformSelecter(_:)), withObject: "Test PerformSelecter:"))
    }
    
    func testAssociated(){
        let obj = NSObject()
        obj.associatedObect = "lben"
        XCTAssertEqual(obj.associatedObect, "lben")
    }
    
    func testObjcMsgSend() {
        XCTAssertTrue( NSObject().at_testMethodForSelector())
    }
    
    func testSwizzleMethod() {
        let obj: NSObject = NSObject()
        XCTAssertTrue(obj.at_testSwizzleMethod())
    }
    
    func testReplaceMethod() {
        let obj: NSObject = NSObject()
        XCTAssertTrue(obj.at_testReplaceMethod())
    }
    
    func testForwardInvocation() {
        let collection: AnyObject = CATCollection()
        collection.setObject("hello", forKey: "key")
        collection.addObject("hello")
        XCTAssertTrue((collection.array as Array).count > 0 && (collection.dic as Dictionary).count > 0)
    }
    
    func testDaymicResolution() {
        XCTAssertTrue((CATCollection().performSelector(Selector( "testDynamicResolue"))) != nil)
    }
    
    func testJSParser() {
        JSParser().simpleTransferFromJsToObjc()
        JSParser().simpleTransferFromObjcToJs()
    }
    
    func testCATRuntimer() {
        CATRuntimer().test()
    }
    
}
