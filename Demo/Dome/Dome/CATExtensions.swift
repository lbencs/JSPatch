//
//  CATExtensions.swift
//  Dome
//
//  Created by lbencs on 7/23/16.
//  Copyright © 2016 lben. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    private struct AssociatedKeys {
        static var associatedObjectKey = "associatedObjectKey"
    }
    
    var associatedObect: String? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.associatedObjectKey) as? String
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.associatedObjectKey,
                                     newValue as NSString?,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension NSObject {
    
    class func swizzleMethods(origSelector: Selector, withSelector swizzleSelector: Selector){
        let originalMethod = class_getInstanceMethod(self.classForCoder(), origSelector)
        let swizzleMethod = class_getInstanceMethod(self.classForCoder(), swizzleSelector)
        
        let didAddMethod: Bool = class_addMethod(self.classForCoder(),
                                                 origSelector,
                                                 method_getImplementation(swizzleMethod),
                                                 method_getTypeEncoding(swizzleMethod))
        if didAddMethod {
            class_replaceMethod(self.classForCoder(),
                                swizzleSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        }else{
            method_exchangeImplementations(originalMethod, swizzleMethod)
        }
    }
    
}
extension UIViewController {
    
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        if self !== UIViewController.self {
            return
        }
        
        dispatch_once(&Static.token) { 
            self.swizzleMethods(#selector(UIViewController.viewWillAppear(_:)), withSelector: #selector(UIViewController.swizzle_viewWillAppear(_:)))
        }
    }
    
    func swizzle_viewWillAppear(animated: Bool) {
        self.swizzle_viewWillAppear(animated)
        print("\(self) swizzle_ViewWillAppear");
    }
}

extension NSObject{
    
    func at_perfomSelecter(aSelecter: Selector, objects: AnyObject ...) -> AnyObject? {
        //swift 版本暂时不知道怎么实现
//        let method: Method = class_getInstanceMethod(self.dynamicType, aSelecter)
//        
//        guard method != nil else {
//            return nil
//        }
//        
//        let implementation = method_getImplementation(method)
//        
//        typealias Funcation = @convention(c)(Any)
//        
        
        return nil
    }
    
}

extension NSObject{
    public func at_testPerformSelecter(message: String) -> String? {
        print("at_testPerformSelecter message is: \(message)")
        return "at_testPerformSelecter"
    }
}

