//
//  ViewController.swift
//  Dome
//
//  Created by lben on 5/17/16.
//  Copyright © 2016 lben. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
    override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
        var error : NSError? = nil
        
        self.testPointer(&error)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func showAlert() -> Void {
        let alert = UIAlertView()
        alert.title = "AlertView"
        alert.message = "AlertMessage"
        alert.addButtonWithTitle("Calcel")
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func testPointer(inout pointer: NSError?) -> Void {
//        NSURLSession.provideImageData(<#T##data: UnsafeMutablePointer<Void>##UnsafeMutablePointer<Void>#>, bytesPerRow: <#T##Int#>, origin: <#T##Int#>, <#T##y: Int##Int#>, size: <#T##Int#>, <#T##height: Int##Int#>, userInfo: <#T##AnyObject?#>)
        let error = NSError(domain: "www.baidu.com", code: Int(10010), userInfo: ["errMsg":"domain error"])
        pointer = error
        print("unsafepointer is:",pointer)
    }
    
}

