//
//  Utils.swift
//  MyStride
//
//  Created by KMHK on 7/10/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit
import Alamofire


var sharedUtils: Utils?

class Utils: NSObject {
	
	let colorBk = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
	let colorDisabledBk = UIColor(red: 55/255.0, green: 188/255.0, blue: 155/255.0, alpha: 0.6)
	let colorLightBk = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
	let colorGreyBk = UIColor(red: 120/255.0, green: 125/255.0, blue: 133/255.0, alpha: 1.0)
	let colorLightGreyBk = UIColor(red: 190/255.0, green: 185/255.0, blue: 193/255.0, alpha: 1.0)
	let colorBackBtn = UIColor(red: 58/255.0, green: 173/255.0, blue: 143/255.0, alpha: 1.0)
	let colorBtn = UIColor(red: 58/255.0, green: 173/255.0, blue: 143/255.0, alpha: 1.0)
	let colorAlert = UIColor(red: 55/255.0, green: 188/255.0, blue: 155/255.0, alpha: 1.0)
	let colorWarning = UIColor(red: 218/255.0, green: 68/255.0, blue: 83/255.0, alpha: 1.0)
	
	let fontTitle = UIFont(name: "Montserrat-Bold", size: 16.0)
	let fontButton = UIFont(name: "Montserrat-Bold", size: 14.0)
	let fontNote = UIFont(name: "Montserrat-Regular", size: 13.0)
	let fontText = UIFont(name: "Montserrat-Regular", size: 16.0)
	let fontWarning = UIFont(name: "Montserrat-Regular", size: 11.0)
	
	
    // MARK: -
	
    static func sharedInstance() -> Utils {
		
		if sharedUtils == nil {
			sharedUtils = Utils.init()
			
			return sharedUtils!
		}
		
		return sharedUtils!
    }
	
	
	static func isReachableNetwork(completion: ((Bool) -> Swift.Void)?) {
		let reachabilityManager = NetworkReachabilityManager()

		reachabilityManager?.startListening()
		reachabilityManager?.listener = { _ in
			if let isNetworkReachable = reachabilityManager?.isReachable, isNetworkReachable == true {
				// available network
				completion!(true)
			} else {
				// not available network
				completion!(false)
			}
		}
	}
	
	
	// MARK: -
	
	func localeString(_ string: String) -> String {
		return NSLocalizedString(string, comment: "")
	}
}


// MARK: -

extension String {
	var isNumeric: Bool {
		guard self.count > 0 else { return true }
		let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
		return Set(self).isSubset(of: nums)
	}
	
	var phoneNumFormat: String {
		var val = "-" + self[self.index(self.endIndex, offsetBy: -4)...]
		val = self[self.index(self.endIndex, offsetBy: -7)..<self.index(self.endIndex, offsetBy: -4)] + val
		val = ") " + val
		val = self[self.index(self.endIndex, offsetBy: -10)..<self.index(self.endIndex, offsetBy: -7)] + val
		val = " (" + val
		val = self[..<self.index(self.endIndex, offsetBy: -10)] + val
		return val
	}
}
