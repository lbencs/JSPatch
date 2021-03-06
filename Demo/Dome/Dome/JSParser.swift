//
//  JSParser.swift
//  Dome
//
//  Created by lben on 7/4/16.
//  Copyright © 2016 lben. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit

class JSParser: NSObject {
	
	let jsContext = JSContext()

	func simpleTransferFromJsToObjc() -> Void {
		func sendMessage(message: String) -> String{
            return "simpleTransferFromJsToObjc_sendMessage:" + message
		}
		
		let sendMessageFromJsToObjc: @convention(block) String -> String = { input in
			return sendMessage(input)
		}
		let showAlertView: @convention(block) String -> Void = { input in
			UIAlertView(title: "alert", message: "Alert message:"+input, delegate: nil, cancelButtonTitle: "OK").show()
		}
		
		jsContext.setObject(unsafeBitCast(sendMessageFromJsToObjc, AnyObject.self), forKeyedSubscript: "sendMessageToObjc")
		jsContext.setObject(unsafeBitCast(showAlertView, AnyObject.self), forKeyedSubscript: "sendAlertMessage")
		
        print("log----------------------")
		print(jsContext.evaluateScript("sendMessageToObjc(' Message from js.')"))
		jsContext.evaluateScript("sendAlertMessage('This is a alert Message from JS')")
        print("log----------------------")
	}
    
	func simpleTransferFromObjcToJs() -> Void {
		
		let script =
			"var printHello = function(){ return \"Hello, i'am is js from Objc\"};" +
			"var num = 5 + 5;" +
			"var names = ['Grace','lben','Sun'];" +
			"var triple = function(value) { return value * 3 };"
		
		jsContext.evaluateScript(script)
		
		let stringV: JSValue = jsContext.evaluateScript("printHello()")
		print(stringV.toString())
		
		let tripleNum: JSValue = jsContext.evaluateScript("triple(num)")
		print(tripleNum.toInt32())
		
		let name = jsContext.evaluateScript("names[0]")
		print(name.toString())
		
	}
}