//
//  SignInUpModel.swift
//  MyStride
//
//  Created by KMHK on 7/11/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSLambda


var gSignInUpModel: SignInUpModel?


class SignInUpModel: NSObject {
	
	var userName: String?
	var session: String?
	
	var tokenAccess: String?
	var tokenID: String?
	var tokenRefresh: String?
	
	var isSignUp: Bool = true

	var firstName: String?
	var lastName: String?
	var countryCode: String?
	var phoneNumber: String? {
		didSet {
			phoneNumber = phoneNumber?.replacingOccurrences(of: "-", with: "")
			phoneNumber = phoneNumber?.replacingOccurrences(of: " ", with: "")
		}
	}

	
	// MARK: -
	
	static func sharedInstance() -> SignInUpModel {
		
		if gSignInUpModel == nil {
			gSignInUpModel = SignInUpModel.init()
			
			return gSignInUpModel!
		}
		
		return gSignInUpModel!
	}
	
	
	// MARK: -
	
	override init() {
		super.init()
		
		// testing for remove user
//		CognitoHelper.sharedInstance().invocateLambda(name: "resetSignUpProcess",
//															  payload: ["user_id" : "user_id-8A138E8D-8C9D-4BC8-994D-AF363FD06BA8"])
	}
	
	
	// MARK: - methods for cognito and lambda
	
	func signUp(completed: (() -> ())?, resign: (()->())?, failed: ((NSError) -> ())?, resignFailed:((NSError)->())?) {
		userName = getUserID()
		
		guard let _firstName = firstName, !_firstName.isEmpty,
			let _lastName = lastName, !_lastName.isEmpty,
			let _locale = countryCode, !_locale.isEmpty,
			let _phoneNumber = phoneNumber, !_phoneNumber.isEmpty else {
				
				if let _failed = failed {
					_failed(NSError(domain: Utils.sharedInstance().localeString("Unknown Error"), code: 404, userInfo: nil))
				}
				return
		}
		
		// send sign up request
		CognitoHelper.sharedInstance().signUp(userID: userName!,
											firstName: firstName!,
											  lastName: lastName!,
											  localeCode: countryCode!,
											  phoneNum: phoneNumber!,
											  pwd: "F1r5t6l00d!")
		{ (task) in
			// sign up with error
			if let error = task?.error as NSError? {
				if let _failed = failed {
					if (error.userInfo["__type"] as? String) == "UsernameExistsException" { // exist user name
						self.resendVerification(completed: completed, failed: { (error) in
							self.isSignUp = false
							self.sendAuthReq(completed: resign, failed: resignFailed)
						})
					} else {
						DispatchQueue.main.async(execute: {
							_failed(error)
						})
					}
				}
				
				return
			}
			
			if let result = task?.result  {
				// processing signup
				if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
					if let _completed = completed {
						DispatchQueue.main.async(execute: {
							_completed()
						})
					}
					
				} else {
					if let _failed = failed {
						_failed(NSError(domain: Utils.sharedInstance().localeString("Unknown Error"), code: 404, userInfo: nil))
					}
				}
			}
		}
	}
	
	
	func verifySignUp(code: String, completed: (() -> ())?, failed: ((NSError) -> ())?) {
		CognitoHelper.sharedInstance().verifySignUp(userID: userName!, code: code) { (task) in
			if let error = task?.error as NSError? {
				if let _failed = failed {
					DispatchQueue.main.async(execute: {
						_failed(error)
					})
				}
				return
			}
			
			CognitoHelper.sharedInstance().auth(withName: self.userName!, pwd: "F1r5t6l00d!", completed: { (task) in
				if let error = task?.error as NSError? {
					if let _failed = failed {
						DispatchQueue.main.async(execute: {
							_failed(error)
						})
					}
					return
				}
				
				
				self.tokenAccess = task?.result?.accessToken??.tokenString
				self.tokenID = task?.result?.idToken??.tokenString
				self.tokenRefresh = task?.result?.refreshToken??.tokenString
				
				if let _completed = completed {
					DispatchQueue.main.async(execute: {
						_completed()
					})
				}
			})
		}
	}
	
	
	func resendVerification(completed: (() -> ())?, failed: ((NSError) -> ())?) {
		CognitoHelper.sharedInstance().resendVerification(userID: userName!) { (task) in
			if let error = task?.error as NSError? {
				if let _failed = failed {
					DispatchQueue.main.async(execute: {
						_failed(error)
					})
				}
				return
			}
			
			if let _completed = completed {
				DispatchQueue.main.async(execute: {
					_completed()
				})
			}
		}
	}
	
	
	func sendAuthReq(completed: (() -> ())?, failed: ((NSError) -> ())?) {
		CognitoHelper.sharedInstance().sendAuthReq(phone: phoneNumber!) { (task) in
			if let error = task?.error as NSError? {
				if let _failed = failed {
					DispatchQueue.main.async(execute: {
						_failed(error)
					})
				}
				return
			}
			
			self.userName = task?.result?.challengeParameters["USERNAME"]
			self.session = task?.result?.session
			
			if let _completed = completed {
				DispatchQueue.main.async(execute: {
					_completed()
				})
			}
		}
	}
	
	
	func verifyAuth(code: String, completed: (() -> ())?, failed: ((NSError) -> ())?) {
		guard let _ = session, let _ = userName else {
			if let _failed = failed {
				_failed(NSError(domain: Utils.sharedInstance().localeString("Unknown Error"), code: 404, userInfo: nil))
			}
			return
		}
		
		CognitoHelper.sharedInstance().verifyAuth(session: session!, username: userName!, code: code) { (task) in
			if let error = task?.error as NSError? {
				if let _failed = failed {
					DispatchQueue.main.async(execute: {
						_failed(error)
					})
				}
				return
			}
			
			self.tokenAccess = task?.result?.authenticationResult??.accessToken
			self.tokenID = task?.result?.authenticationResult??.idToken
			self.tokenRefresh = task?.result?.authenticationResult??.refreshToken
			
			if let _completed = completed {
				DispatchQueue.main.async(execute: {
					_completed()
				})
			}
		}
	}
	
	
	// private methods
	
	private func getUserID() -> String {
		var uid = "user_id-"
		
		uid = uid + UIDevice.current.identifierForVendor!.uuidString
		
		return uid
	}
}
