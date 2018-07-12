//
//  SignupPhoneVC.swift
//  MyStride
//
//  Created by KMHK on 7/10/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class SignupPhoneVC: UIViewController {
	
	@IBOutlet weak var txtPhone: UITextField!
	@IBOutlet weak var btnContinue: UIButton!
	
	var txtPrefix: NonCursorTextField?
	var countryPicker: CountryCodePicker?
	
	let utils = Utils.sharedInstance()
	let model = SignInUpModel.sharedInstance()
	

	// MARK: -
	
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title view to navigation
		let _titleView = UILabel()
		_titleView.text = (model.isSignUp == true) ? utils.localeString("Sign Up") : utils.localeString("Log In")
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
		_lblNote.text = utils.localeString("Please enter your mobile number")
		_lblNote.font = utils.fontNote
		_lblNote.textColor = utils.colorGreyBk
		
		// set color to text view and buttons
		btnContinue.setTitle(utils.localeString("SEND CODE"), for: .normal)
		initButton(button: btnContinue, enable: false)
		
		txtPrefix = NonCursorTextField(frame: CGRect(x: 0, y: 0, width: 56, height: txtPhone.frame.size.height))
		txtPrefix?.borderStyle = .none
		txtPrefix?.font = utils.fontText
		txtPrefix?.textColor = utils.colorGreyBk
		txtPrefix?.backgroundColor = utils.colorLightBk
		txtPrefix?.textAlignment = .right
		txtPrefix?.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: txtPhone.frame.size.height))
		txtPrefix?.rightViewMode = .always
		
		txtPhone.leftView = txtPrefix
		initTextField(textField: txtPhone, flag: false)
		
		// add tap gesture
		view.addGestureRecognizer(UITapGestureRecognizer(target: self,
														 action: #selector(viewTapGesture(sender:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// for country code picker
		if countryPicker != nil {
			return
		}
		
		countryPicker = CountryCodePicker.initPicker(frame: CGRect(x: 0, y: view.frame.size.height - 302, width: view.frame.size.width, height: 302),
		toolBk: utils.colorBk, pickerBk: utils.colorLightBk, pickerTxt: UIColor.black,
		tool: utils.fontButton!, picker: utils.fontText!, bShowPhoneNumber: true, bShowFlag: false)
		countryPicker?.countryCodePickerDelegate = self
		countryPicker?.setCountry("US")
		txtPrefix?.inputView = countryPicker
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
	
	
	// MARK: -
	
	@objc func btnBackTapped(sender: Any){
		if navigationController?.viewControllers[0] == self {
			let transition = CATransition()
			transition.duration = 0.2
			transition.type = kCATransitionPush
			transition.subtype = kCATransitionFromLeft
			transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
			view.window!.layer.add(transition, forKey: kCATransition)
			
			navigationController?.dismiss(animated: true, completion: nil)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	
	@objc func viewTapGesture(sender: Any) {
		txtPrefix?.resignFirstResponder()
		txtPhone.resignFirstResponder()
	}
	
	
	@IBAction func btnContinueTapped(_ sender: Any) {
		viewTapGesture(sender: self)
		
		WaitingView.show(view, type: .white, rect: CGRect(x: btnContinue.frame.size.width / 4, y: btnContinue.frame.origin.y, width: btnContinue.frame.size.height, height: btnContinue.frame.size.height))
		
		model.phoneNumber = (txtPrefix?.text)! + (txtPhone?.text)!
		
		Utils.isReachableNetwork { (isReachable) in
			WaitingView.hide()
			
			if isReachable == false {
				AlertView.show(self.view, type: .warning, pos: CGPoint(x: 0, y: (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.size.height)!))
				return
			}
			
			self.performSegue(withIdentifier: "segueNext", sender: nil)
		}
	}
	
	
	// MARK: -
	
	func parsePhoneNumber(str: String) -> String {
		let tmp = str.replacingOccurrences(of: "-", with: "")
		var val: String?
		
		let len = tmp.count
		if len <= 3 {
			val = tmp
		} else if len <= 6 {
			val = tmp[..<tmp.index(tmp.startIndex, offsetBy: 3)] + "-"
			val = val! + tmp[tmp.index(tmp.startIndex, offsetBy: 3)...]
		} else {
			val = tmp[..<tmp.index(tmp.startIndex, offsetBy: 3)] + "-"
			val = val! + tmp[tmp.index(tmp.startIndex, offsetBy: 3)..<tmp.index(tmp.startIndex, offsetBy: 6)]
			val = val! + "-"
			val = val! + tmp[tmp.index(tmp.startIndex, offsetBy: 6)...]
		}
		
		return val!
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: -

extension SignupPhoneVC: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		// get new string
		let maxLength = 12
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		
		let tmp = (newString as String).replacingOccurrences(of: "-", with: "")
		
		if !tmp.isNumeric {
			return false
		}
		
		let txt = parsePhoneNumber(str: newString as String)
		if txt.count <= maxLength {
			txtPhone.text = txt
		}
		
		// set text and button
		initTextField(textField: txtPhone, flag: (txtPhone.text != ""))
		initButton(button: btnContinue, enable: (txtPhone.text?.count == maxLength))
		
		return false
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		txtPhone.resignFirstResponder()
		
		return true
	}
}


// MARK: -

extension SignupPhoneVC: CountryCodePickerDelegate {
	func countryCodePicker(_ picker: CountryCodePicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage?) {
		txtPrefix?.text = phoneCode
	}
	
	
	func countryCodePicker(_ picker: CountryCodePicker, didFinished finished: Bool) {
		viewTapGesture(sender: picker)
	}
}
