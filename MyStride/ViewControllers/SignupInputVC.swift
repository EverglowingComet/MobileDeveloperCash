//
//  SignupInputVC.swift
//  MyStride
//
//  Created by KMHK on 7/10/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class SignupInputVC: UIViewController {
	
	@IBOutlet weak var btnContinue: UIButton!
	@IBOutlet weak var txtFirstName: UITextField!
	@IBOutlet weak var txtLastName: UITextField!
	
	let utils = Utils.sharedInstance()
	

	// MARK: -
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // set title view to navigation
		let _titleView = UILabel()
		_titleView.text = utils.localeString("Sign Up")
		_titleView.font = utils.fontTitle
		_titleView.textColor =  utils.colorLightBk
		navigationItem.titleView = _titleView
		
		// set cancel button to navigation
		let _backView = UIButton(type: .system)
		_backView.setTitle(utils.localeString("Cancel"), for: .normal)
		_backView.setTitleColor(utils.colorBackBtn, for: .normal)
		_backView.titleLabel?.font = utils.fontButton
		_backView.addTarget(self, action: #selector(btnBackTapped(sender:)), for: .touchUpInside)
		let _back = UIBarButtonItem(customView: _backView)
		navigationItem.leftBarButtonItem = _back
		
		// customize note
		let _lblNote = view.viewWithTag(101) as! UILabel
		_lblNote.text = utils.localeString("Please enter your first and last name")
		_lblNote.font = utils.fontNote
		_lblNote.textColor = utils.colorGreyBk
		
		// set color to text view and buttons
		txtFirstName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: txtFirstName.frame.size.height))
		txtFirstName.placeholder = utils.localeString("First Name")
		
		txtLastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: txtLastName.frame.size.height))
		txtLastName.placeholder = utils.localeString("Last Name")
		
		btnContinue.setTitle(utils.localeString("CONTINUE"), for: .normal)
		
		// add tap gesture
		view.addGestureRecognizer(UITapGestureRecognizer(target: self,
														 action: #selector(viewTapGesture(sender:))))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// add text notification
		NotificationCenter.default.addObserver(self,
											   selector: #selector(txtNotify(sender:)),
											   name: NSNotification.Name.UITextFieldTextDidChange,
											   object: nil)
		
		txtFirstName.text = ""
		initTextField(textField: txtFirstName, flag: false)
		
		txtLastName.text = ""
		initTextField(textField: txtLastName, flag: false)
		
		initButton(button: btnContinue, enable: false)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	// MARK: - initialize method
	
	func initTextField(textField: UITextField, flag: Bool) {
		textField.leftViewMode = .always
		textField.delegate = self
		textField.font = utils.fontText
		textField.textColor = utils.colorGreyBk
		textField.backgroundColor = utils.colorLightBk
		textField.layer.masksToBounds = true
		textField.layer.borderWidth = 3.0
		textField.layer.cornerRadius = textField.frame.size.height / 2
		textField.layer.borderColor = (flag == true) ? utils.colorBk.cgColor : utils.colorLightGreyBk.cgColor
	}
	
	
	func initButton(button: UIButton, enable: Bool) {
		button.layer.masksToBounds = true
		button.layer.cornerRadius = btnContinue.frame.size.height / 2
		button.setTitleColor(utils.colorLightBk, for: .normal)
		button.titleLabel?.font = utils.fontButton
		button.backgroundColor = (enable == true) ? utils.colorBtn : utils.colorDisabledBk
		button.isEnabled = enable
	}
	
	
	// MARK: - action method
	
	@IBAction func btnContinueTapped(_ sender: Any) {
		viewTapGesture(sender: sender)
		
		performSegue(withIdentifier: "segueNext", sender: nil)
	}
	
	
	@objc func btnBackTapped(sender: Any) {
		let transition = CATransition()
		transition.duration = 0.2
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromLeft
		transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		view.window!.layer.add(transition, forKey: kCATransition)
		
		navigationController?.dismiss(animated: false, completion: nil)
	}
	
	
	@objc func viewTapGesture(sender: Any) {
		txtFirstName.resignFirstResponder()
		txtLastName.resignFirstResponder()
	}
	
	
	@objc func txtNotify(sender: Any) {
		initTextField(textField: txtFirstName, flag: (txtFirstName.text != ""))
		initTextField(textField: txtLastName, flag: (txtLastName.text != ""))
		
		initButton(button: btnContinue, enable: (txtFirstName.text != "" && txtLastName.text != ""))
	}

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


// MARK: -

extension SignupInputVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		txtFirstName.resignFirstResponder()
		
		if textField == txtFirstName {
			txtLastName.becomeFirstResponder()
		} else {
			txtLastName.resignFirstResponder()
		}
		
		return true
	}
}
