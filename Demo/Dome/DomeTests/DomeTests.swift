//
//  DomeTests.swift
//  DomeTests
//
//  Created by lben on 5/17/16.
//  Copyright © 2016 lben. All rights reserved.
//

import XCTest
@testable import Dome

class DomeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //  
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
    
    
	
	func testForwardInvocation() {
		XCTAssertTrue(CATForwardInvocation().respondsToSelector(#selector(CATForwardInvocation.testFunction(_:))))
	}
    
	func testSwizzleForwardInvocation() {
		
		let invocation: AnyObject = CATForwardInvocation()
		
		invocation.swizzle()
		
		XCTAssertTrue(invocation.testFunction("message"))
		
		if invocation.respondsToSelector(#selector(CATForwardInvocation.testFunction(_:))) {
		}
		
		invocation.addObject("Add Object Message.")
		XCTAssertTrue((invocation.array as Array).count > 0)
	}
}
 