//
//  SignInUpModel.swift
//  MyStride
//
//  Created by KMHK on 7/11/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

var gSignInUpModel: SignInUpModel?

class SignInUpModel: NSObject {
	
	var isSignUp: Bool = true
	
	var phoneNumber: String? {
		didSet {
			phoneNumber = phoneNumber?.replacingOccurrences(of: "-", with: "")
			phoneNumber = phoneNumber?.replacingOccurrences(of: " ", with: "")
		}
	}

	
	static func sharedInstance() -> SignInUpModel {
		
		if gSignInUpModel == nil {
			gSignInUpModel = SignInUpModel.init()
			
			return gSignInUpModel!
		}
		
		return gSignInUpModel!
	}
	
	
	// MARK: -
	
	func isValidSMS(code: String) -> Bool {
		if code == "123456" {
			return true
		}
		
		return false
	}
}
