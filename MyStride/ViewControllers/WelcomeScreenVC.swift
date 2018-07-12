//
//  WelcomeScreenVC.swift
//  MyStride
//
//  Created by KMHK on 7/10/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class WelcomeScreenVC: UIViewController {
	
	@IBOutlet weak var imgViewWelcome: UIImageView!
	@IBOutlet weak var btnSignup: UIButton!
	@IBOutlet weak var btnLogin: UIButton!
	
	let utils = Utils.sharedInstance()
	let model = SignInUpModel.sharedInstance()
	

	// MARK: -
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = utils.colorBk
		
		btnSignup.setTitle(utils.localeString("SIGN UP"), for: .normal)
		btnSignup.backgroundColor = utils.colorLightBk
		btnSignup.setTitleColor(utils.colorBk, for: .normal)
		btnSignup.titleLabel?.font = utils.fontTitle
		btnSignup.layer.masksToBounds = true
		btnSignup.layer.cornerRadius = btnSignup.frame.size.height / 2
		
		btnLogin.setTitle(utils.localeString("LOG IN"), for: .normal)
		btnLogin.backgroundColor = utils.colorBk
		btnLogin.setTitleColor(utils.colorLightBk, for: .normal)
		btnLogin.titleLabel?.font = utils.fontTitle
		btnLogin.layer.masksToBounds = true
		btnLogin.layer.cornerRadius = btnLogin.frame.size.height / 2
		btnLogin.layer.borderWidth = 3
		btnLogin.layer.borderColor = utils.colorLightBk.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    

	// MARK: -
	
	@IBAction func btnSignUpTapped(_ sender: Any) {
		model.isSignUp = true
		
		let transition = CATransition()
		transition.duration = 0.2
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromRight
		transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		view.window!.layer.add(transition, forKey: kCATransition)
		
		let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
		let vc = storyboard.instantiateInitialViewController()
		present(vc!, animated: false, completion: nil)
	}
	
	
	@IBAction func btnLoginTapped(_ sender: Any) {
		model.isSignUp = false
		
		let storyboard = UIStoryboard(name: "PhoneVerify", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "SignupNavVC")
		
		let transition = CATransition()
		transition.duration = 0.2
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromRight
		transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		view.window!.layer.add(transition, forKey: kCATransition)
		
		present(vc, animated: false, completion: nil)
	}
	
}
