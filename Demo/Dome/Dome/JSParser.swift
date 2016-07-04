//
//  JSParser.swift
//  Dome
//
//  Created by lben on 7/4/16.
//  Copyright © 2016 lben. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSParser: NSObject {
	
	let jsContext = JSContext()
	
	func parser() -> Void {
		
        self.simpleTransferFromObjcToJs()
		
        self.simpleTransferFromJsToObjc()
		
	}
	
    
	func simpleTransferFromJsToObjc() -> Void {
		
		func sendMessage(message: String) -> String{
			return "simpleTransferFromJsToObjc_sendMessage:" + message
		}
		
		let sendMessageFromJsToObjc: @convention(block) String -> String = { input in
			return sendMessage(input)
		}
		
		jsContext.setObject(unsafeBitCast(sendMessageFromJsToObjc, AnyObject.self), forKeyedSubscript: "sendMessageToObjc")
		print(jsContext.evaluateScript("sendMessageToObjc(' Message from js.')"))
		
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