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

// for mystride-test
let CognitoIdentityUserPoolRegion: AWSRegionType = .USEast1
let CognitoIdentityUserPoolId = "us-east-1_YA7NmvRlY"
let CognitoIdentityUserPoolAppClientId = "1c2nh32aqirqkkskptg6gts4t4"
let CognitoIdentityPoolId = "us-east-1:5e5cd449-b057-4b66-b593-73a81c3f6cd4"


let AWSCognitoUserPoolsSignInProviderKey = "UserPool"


class SignInUpModel: NSObject {
	
	var isSignUp: Bool = true
	
	var pool: AWSCognitoIdentityUserPool?
	var curUser: AWSCognitoIdentityUser?

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
		
		//setup service config
		let serviceConfig = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
		
		// create pool configuration
		let poolConfig = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,
																 clientSecret: nil,
																 poolId: CognitoIdentityUserPoolId)
		// initialize user pool client
		AWSCognitoIdentityUserPool.register(with: serviceConfig,
											userPoolConfiguration: poolConfig,
											forKey: AWSCognitoUserPoolsSignInProviderKey)
		
		// fetch the user pool client we initialized in above step
		pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
		
		// testing
//		removeUser(id: "user_id-127CE68F-5557-4324-9FBE-7F35DFFB0DD5")
	}
	
	
	// MARK: - methods for cognito and lambda
	
	func signUp(completed: ((AWSTask<AnyObject>?) -> ())?) {
		guard let _firstName = firstName, !_firstName.isEmpty,
			let _lastName = lastName, !_lastName.isEmpty,
			let _locale = countryCode, !_locale.isEmpty,
			let _phoneNumber = phoneNumber, !_phoneNumber.isEmpty else {
				
				if let _completed = completed {
					_completed(nil)
				}
				return
		}
		
		var attributes = [AWSCognitoIdentityUserAttributeType]()
		
		let phone = AWSCognitoIdentityUserAttributeType()
		phone?.name = "phone_number"
		phone?.value = _phoneNumber
		attributes.append(phone!)
		
		let given_name = AWSCognitoIdentityUserAttributeType()
		given_name?.name = "given_name"
		given_name?.value = _firstName
		attributes.append(given_name!)
		
		let family_name = AWSCognitoIdentityUserAttributeType()
		family_name?.name = "family_name"
		family_name?.value = _lastName
		attributes.append(family_name!)
		
		let locale = AWSCognitoIdentityUserAttributeType()
		locale?.name = "locale"
		locale?.value = _locale
		attributes.append(locale!)
		
		pool?.signUp(generateUserID(),
					 password: "F1r5t6l00d!",
					 userAttributes: attributes,
					 validationData: nil).continueWith(block: { (task) -> Any? in

						if let _completed = completed {
							DispatchQueue.main.async(execute: {
								_completed(task as? AWSTask<AnyObject>)
							})
						}

						return nil
		})
	}
	
	
	func verifySMSCode(code: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		curUser?.confirmSignUp(code).continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				DispatchQueue.main.async(execute: {
					_completed(task as? AWSTask<AnyObject>)
				})
			}
			
			return nil
		})
	}
	
	
	func resendSMSCode(completed: ((AWSTask<AnyObject>?) -> ())?) {
		curUser?.resendConfirmationCode().continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				DispatchQueue.main.async(execute: {
					_completed(task as? AWSTask<AnyObject>)
				})
			}
			
			return nil
		})
	}
	
	
	// remove user using lambda with user ID
	func removeUser(id: String) {
		let credentialsProvider = AWSCognitoCredentialsProvider(regionType:  CognitoIdentityUserPoolRegion,
																identityPoolId: CognitoIdentityPoolId)
		let defaultServiceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion,
																  credentialsProvider: credentialsProvider)
		AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
		
		let lambdaInvoker = AWSLambdaInvoker.default()
		
		let invocationRequest = AWSLambdaInvokerInvocationRequest()
		invocationRequest?.functionName = "resetSignUpProcess"
		invocationRequest?.invocationType = AWSLambdaInvocationType.requestResponse
		invocationRequest?.payload = ["user_id" : id]
		
		lambdaInvoker.invoke(invocationRequest!) { (response, error) in
			if (error != nil) {
				print("Error: \(error!)")
			}
		}
	}
	
	
	// MARK: - private method
	
	private func generateUserID() -> String {
		var uid = "user_id-"

		uid = uid + UIDevice.current.identifierForVendor!.uuidString
		
		return uid
	}
}


// MARK: -
extension SignInUpModel: AWSCognitoIdentityInteractiveAuthenticationDelegate {
	
}
