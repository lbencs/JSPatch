//
//  CATMessage.swift
//  Dome
//
//  Created by lben on 7/12/16.
//  Copyright © 2016 lben. All rights reserved.
//

import UIKit

func Log(aKey: String) -> String{
	return aKey;
}


class CATMessage: NSObject {
	func sendMessage() -> Void {
		Log("jaj")
	}
}

extension CATMessage{
//	var name: String? {
//		set{
////			objc_setAssociatedObject(CATMessage.self, #selector(CATMessage.name), <#T##value: AnyObject!##AnyObject!#>, <#T##policy: objc_AssociationPolicy##objc_AssociationPolicy#>)
//		}
//		get{
//		
//		}
//	}
}
