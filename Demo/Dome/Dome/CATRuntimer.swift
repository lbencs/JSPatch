//
//  CATRuntimer.swift
//  Dome
//
//  Created by lben on 7/5/16.
//  Copyright © 2016 lben. All rights reserved.
//

import UIKit


class Model: NSObject {
	
	var string: String = "String"
	let stringLet: String = "StringLet"
	var nsstring: NSString = "NSString"
	let nsstringLet: NSString = "NSStringLet"
	var nsmutablestring: NSMutableString = "NSMutableString"
	let nsmutablestringLet: NSMutableString = "NSMutableStringLet"
	
	var dictionary: Dictionary = ["key":"dictionary"]
	let dictionaryLet: Dictionary = ["key":"dictionaryLet"]
	var nsdictionary: NSDictionary = ["key":"NSDictionary"];
	let nsdictionaryLet: NSDictionary = ["key":"NSDictionaryLet"]
	var nsmutabledictionary: NSMutableDictionary = ["key":"NSMutableDictionary"]
	let nsmutabledictionaryLet: NSMutableDictionary = ["key":"NSMutableDictionaryLet"]
	
	var array: Array = ["Array"]
	let arrayLet: Array = ["ArrayLet"]
	var nsarray: NSArray = ["NSArray"]
	let nsarrayLet: NSArray = ["NSArrayLet"]
	var nsmutablearray: NSMutableArray = ["NSMutableArray"]
	let nsmutablearrayLet: NSMutableArray = ["NSMutableArrayLet"]
	
	var number: NSNumber = 2
	var intNum: Int = 1
	var doubleNum: Double = 2.0
	var floatNum: Float = 1.0
	
	func addItemToNSMutableDictionary(item: [String: String]) -> Void {
		self.nsmutabledictionary.setDictionary(item)
	}
	func removeItemFromNSMutableDictionary(key aKey: String) -> Void {
		self.nsmutabledictionary.removeObjectForKey(aKey)
	}
}
class Animal: Model {
	var name: String?
	var age: Int?
	var birthday: String?
	
}
class Dog: Animal {
}
class Cat: Animal {
}

/*
属性字符串以T@encode(type) + ... + V实例变量名
R --- readonly
C --- copy
& --- retain
N --- nonatomic
G(name) --- getter=(name)
S(name) --- setter=(name)
D --- @dynamic
W --- weak
P --- 用于垃圾回收机制
*/
struct CATAttribute {
	var name: String?
	var value: String?
}
struct CATProperty {
	var name: String?
	var attributeName: String?
	var attributes = [CATAttribute]()
}
struct CATIvar {
	var name: String?
	var typeEncoding: String?
	var offset: Int?
}
struct CATMethodDescription {
	var name: Selector?
	var types: String?
}
struct CATMethod {
	var name: Selector?
	var returnType: String?
	var typeEncoding: String?
	var argumentType = [String]()
	var imp: IMP?
	var methodDescription: CATMethodDescription?
}



/*
const Type *  UnsafePointer
Type *        UnsafeMutablePointer
*/

class CATRuntimer: NSObject {
	
	func test() -> Void
	{
		propertyList(Model.classForCoder())
		
		dump(self.ivarList(Model.classForCoder()))
		dump(self.propertyList(Model.classForCoder()))
		dump(self.methodList(Model.classForCoder()))
        self.dynamicClass()
	}
	
	func property() -> Void
	{
//		class_pro
	}
	
	func methodList(aClass: AnyClass!) -> [CATMethod]{
		
		var methods = [CATMethod]()
		var count: UInt32 = 0
		
		let methodList = class_copyMethodList(aClass, &count)
		for i in 0 ..< Int(count)
		{
			let method_t = methodList[i]
			var method = CATMethod()
			
			method.name = method_getName(method_t)
			
			method.returnType = String(UTF8String: method_copyReturnType(method_t))
			
			let methodDescription: UnsafeMutablePointer<objc_method_description> = method_getDescription(method_t)
			let methodD: objc_method_description = methodDescription.memory
			method.methodDescription = CATMethodDescription(name: methodD.name, types: String(UTF8String: methodD.types))
			
			method.typeEncoding = String(UTF8String: method_getTypeEncoding(method_t))
			
			for i in 0 ..< method_getNumberOfArguments(method_t)
			{
				if let argumentType = String(UTF8String: method_copyArgumentType(method_t, i)){
					method.argumentType.append(argumentType)
				}
			}
			
			method.imp = method_getImplementation(method_t)
			
			methods.append(method);
		}
		
		return methods;
	}
	
	func ivarList(aClass: AnyClass!) -> [CATIvar]
	{
		var count: UInt32 = 0
		let ivarList: UnsafeMutablePointer<Ivar> = class_copyIvarList(aClass, &count)
		var ivars = [CATIvar]()
		for i in 0 ..< Int(count)
		{
			let ivar: Ivar = ivarList[i]
			var cIvar = CATIvar()
	
			cIvar.name = String(UTF8String: ivar_getName(ivar))
			cIvar.typeEncoding = String(UTF8String: ivar_getTypeEncoding(ivar))
			cIvar.offset = ivar_getOffset(ivar)
			
			ivars.append(cIvar)
		}
		return ivars
	}
	
	func propertyList(aClass: AnyClass!) -> [CATProperty]
	{
		var count: UInt32 = 0
		var propertys = [CATProperty]()
		let propertyList = class_copyPropertyList(aClass, &count)
		
		for i in 0 ..< Int(count)
		{
			let property_t: objc_property_t = propertyList[i]
			var cProperty = CATProperty()
			
			cProperty.name = String(UTF8String: property_getName(property_t))
			cProperty.attributeName = String(UTF8String: property_getAttributes(property_t))
			
			var count: UInt32 = 0
			let attributeList = property_copyAttributeList(property_t, &count)
			for i in 0 ..< Int(count) {
				let attribute_t: objc_property_attribute_t = attributeList[i]
				var attribute = CATAttribute()
				attribute.name = String(UTF8String: attribute_t.name)
				attribute.value = String(UTF8String: attribute_t.value)
				cProperty.attributes.append(attribute)
			}
			propertys.append(cProperty)
		}
		return propertys;
	}
	
	func propertyName(aClass: AnyClass, aName: String) -> String?
	{
		let propertyT = class_getProperty(aClass, aName)
		return propertyT != nil ? String(UTF8String: property_getName(propertyT)) : nil
	}
	
	func addProperty(aClass: AnyClass, aName: String, aAttribute: String) -> String?
    {
//		class_addProperty(<#T##cls: AnyClass!##AnyClass!#>, <#T##name: UnsafePointer<Int8>##UnsafePointer<Int8>#>, <#T##attributes: UnsafePointer<objc_property_attribute_t>##UnsafePointer<objc_property_attribute_t>#>, <#T##attributeCount: UInt32##UInt32#>)
		return nil
	}
	
	func dynamicClass() -> Void {
        
        let TigerClass: AnyClass = objc_allocateClassPair(Animal.self, "Tiger", 0)
		
		let attribute = objc_property_attribute_t(name: "T".cStringUsingEncoding(NSUTF8StringEncoding), value: "@\"NSString\"".cStringUsingEncoding(NSUTF8StringEncoding))
		
        class_addIvar(TigerClass, "ivar1", sizeof(NSObject), UInt8(log2(Double(sizeof(NSObject)))), "@")
        class_addIvar(TigerClass, "ivar2", sizeof(NSObject), UInt8(log2(Double(sizeof(NSObject)))), "@")
        class_addIvar(TigerClass, "ivar3", sizeof(NSObject), UInt8(log2(Double(sizeof(NSObject)))), "@")
		class_addProperty(TigerClass, "property1", [attribute], 1)
        

//        class_addMethod(<#T##cls: AnyClass!##AnyClass!#>, <#T##name: Selector##Selector#>, <#T##imp: IMP##IMP#>, <#T##types: UnsafePointer<Int8>##UnsafePointer<Int8>#>)
//        class_addProtocol(<#T##cls: AnyClass!##AnyClass!#>, <#T##protocol: Protocol!##Protocol!#>)
		
        objc_registerClassPair(TigerClass)
        dump(TigerClass)
        dump(ivarList(TigerClass))
        dump(propertyList(TigerClass))
		
//        let tiger = TigerClass.alloc()
//        print(tiger)
	}
}
