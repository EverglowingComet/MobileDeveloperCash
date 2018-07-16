//
//  CognitoHelper.swift
//  MyStride
//
//  Created by KMHK on 7/12/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSCore
import AWSLambda


// for mystride-test
let CognitoIdentityUserPoolRegion: AWSRegionType = .USEast1
let CognitoIdentityUserPoolId = "us-east-1_YA7NmvRlY"
let CognitoIdentityUserPoolAppClientId = "1c2nh32aqirqkkskptg6gts4t4"
let CognitoIdentityPoolId = "us-east-1:5e5cd449-b057-4b66-b593-73a81c3f6cd4"


var gCognitoHelper: CognitoHelper?


class CognitoHelper: NSObject {

	// MARK: -
	
	static func sharedInstance() -> CognitoHelper {
		
		if gCognitoHelper == nil {
			gCognitoHelper = CognitoHelper.init()
			
			return gCognitoHelper!
		}
		
		return gCognitoHelper!
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
											forKey: "UserPool")
		
		// setup credential
		let credentialsProvider = AWSCognitoCredentialsProvider(regionType:  CognitoIdentityUserPoolRegion,
																identityPoolId: CognitoIdentityPoolId)
		
		let defaultServiceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion,
																  credentialsProvider: credentialsProvider)
		
		// set identity pool configuration as a default
		AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
		
		// identity provider configuration
		AWSCognitoIdentityProvider.register(with: defaultServiceConfiguration!, forKey: "IdentityProvider")
	}
	
	
	// MARK: - methods for cognito and lambda
	
	func signUp(userID: String, firstName: String, lastName: String, localeCode: String, phoneNum: String, pwd: String,
				completed: ((AWSTask<AnyObject>?) -> ())?) {
		let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
		
		var attributes = [AWSCognitoIdentityUserAttributeType]()
		attributes.append(cognitorAttribue(attributeName: "phone_number", value: phoneNum))
		attributes.append(cognitorAttribue(attributeName: "given_name", value: firstName))
		attributes.append(cognitorAttribue(attributeName: "family_name", value: lastName))
		attributes.append(cognitorAttribue(attributeName: "locale", value: localeCode))
		
		pool.signUp(userID,
					 password: pwd,
					 userAttributes: attributes,
					 validationData: nil).continueWith(block: { (task) -> Any? in
						
						if let _completed = completed {
							_completed(task as? AWSTask<AnyObject>)
						}
						
						return nil
					})
	}
	
	
	func verifySignUp(userID: String, code: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		let provider: AWSCognitoIdentityProvider? = AWSCognitoIdentityProvider(forKey: "IdentityProvider")
		guard provider != nil else {
			fatalError("AWSCognitoIdentityProvider not registered!")
		}
		
		let req = AWSCognitoIdentityProviderConfirmSignUpRequest()
		req?.clientId = CognitoIdentityUserPoolAppClientId
		req?.confirmationCode = code
		req?.username = userID
		
		provider?.confirmSignUp(req!).continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				_completed(task as? AWSTask<AnyObject>)
			}
			return nil
		})
	}
	
	
	func resendVerification(userID: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		let provider: AWSCognitoIdentityProvider? = AWSCognitoIdentityProvider(forKey: "IdentityProvider")
		guard provider != nil else {
			fatalError("AWSCognitoIdentityProvider not registered!")
		}
		
		let req = AWSCognitoIdentityProviderResendConfirmationCodeRequest()
		req?.clientId = CognitoIdentityUserPoolAppClientId
		req?.username = userID
		
		provider?.resendConfirmationCode(req!).continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				_completed(task as? AWSTask<AnyObject>)
			}
			
			return nil
		})
	}
	
	
	func auth(withName: String, pwd: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
		let user = pool.getUser(withName)
		
		user.getSession(withName, password: pwd, validationData: nil).continueWith { (task) -> Any? in
			if let _completed = completed {
				_completed(task as? AWSTask<AnyObject>)
			}
			
			return nil
		}
	}
	
	
	func sendAuthReq(phone: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		let provider: AWSCognitoIdentityProvider? = AWSCognitoIdentityProvider(forKey: "IdentityProvider")
		guard provider != nil else {
			fatalError("AWSCognitoIdentityProvider not registered!")
		}
		
		let authReq = AWSCognitoIdentityProviderInitiateAuthRequest()
		authReq?.authFlow = .customAuth
		authReq?.clientId = CognitoIdentityUserPoolAppClientId
		authReq?.authParameters = ["USERNAME": phone]
		
		provider?.initiateAuth(authReq!).continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				_completed(task as? AWSTask<AnyObject>)
			}
			return nil
		})
	}
	
	
	func verifyAuth(session: String, username: String, code: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		let provider: AWSCognitoIdentityProvider? = AWSCognitoIdentityProvider(forKey: "IdentityProvider")
		guard provider != nil else {
			fatalError("AWSCognitoIdentityProvider not registered!")
		}
		
		let req = AWSCognitoIdentityProviderRespondToAuthChallengeRequest()
		req?.challengeName = .customChallenge
		req?.clientId = CognitoIdentityUserPoolAppClientId
		req?.session = session
		req?.challengeResponses = ["USERNAME": username,
								   "ANSWER": code]
		
		provider?.respond(toAuthChallenge: req!).continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				_completed(task as? AWSTask<AnyObject>)
			}
			return nil
		})
	}
	
	
	func getUserIdentity(withToken: String, completed: ((AWSTask<AnyObject>?) -> ())?) {
		let provider: AWSCognitoIdentityProvider? = AWSCognitoIdentityProvider(forKey: "IdentityProvider")
		guard provider != nil else {
			fatalError("AWSCognitoIdentityProvider not registered!")
		}
		
		let req = AWSCognitoIdentityProviderGetUserRequest()
		req?.accessToken = withToken
		
		provider?.getUser(req!).continueWith(block: { (task) -> Any? in
			if let _completed = completed {
				_completed(task as? AWSTask<AnyObject>)
			}
			
			return nil
		})
	}
	
	
	
	/* // not using now
	func needAttributeVerficationCode(curUser: AWSCognitoIdentityUser, completed: (()->())?, failed: ((NSError) -> ())?) {
		curUser.getAttributeVerificationCode("phone_number").continueWith(block: { (task) -> Any? in
			if let error = task.error as NSError? {
				if let _failed = failed {
					_failed(error)
				}
				return nil
			}
			
			if let _completed = completed {
				_completed()
			}
			
			return nil
		})
	}
	
	
	func updateUserAttribute(curUser: AWSCognitoIdentityUser, attribues: [AWSCognitoIdentityUserAttributeType], completed: (()->())?, failed: ((NSError) -> ())?) {
		curUser.update(attribues).continueWith { (task) -> Any? in
			if let error = task.error as NSError? {
				if let _failed = failed {
					_failed(error)
				}
				
				return nil
			}
			
			self.needAttributeVerficationCode(curUser: curUser, completed: completed, failed: failed)
			return nil
		}
	}*/
	
	
	func invocateLambda(name: String, payload: Any?, completed: ((Any?)->())? = nil) {
		let lambdaInvoker = AWSLambdaInvoker.default()
		
		let invocationRequest = AWSLambdaInvokerInvocationRequest()
		invocationRequest?.functionName = name //"resetSignUpProcess"
		invocationRequest?.invocationType = AWSLambdaInvocationType.requestResponse
		invocationRequest?.payload = payload
		
		lambdaInvoker.invoke(invocationRequest!) { (response, error) in
			if (error != nil) {
				print("Error: \(error!)")
				return
			}
			
			if let _completed = completed {
				_completed(nil)
			}
		}
	}
	
	
	// MARK: - private method
	
	private func cognitorAttribue(attributeName: String, value: String) -> AWSCognitoIdentityUserAttributeType {
		let attribue = AWSCognitoIdentityUserAttributeType()
		attribue?.name = attributeName
		attribue?.value = value
		return attribue!
	}
}
