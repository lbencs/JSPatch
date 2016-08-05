//
//  ViewController.swift
//  Dome
//
//  Created by lben on 5/17/16.
//  Copyright © 2016 lben. All rights reserved.
//

import UIKit

class CATListViewController: UIViewController {
	
	let jsParser: JSParser = JSParser()
	let runtimer = CATRuntimer()
	
	
    override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    func showAlert() -> Void {
        
		let alert = UIAlertController(title: "Alert", message: "Alert Message", preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert in
		}))
		alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { alert in
		}))
		self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func testPointer(inout pointer: NSError?) -> Void {
        let error = NSError(domain: "www.baidu.com", code: Int(10010), userInfo: ["errMsg":"domain error"])
        pointer = error
        print("unsafepointer is:",pointer)
    }
    
}

