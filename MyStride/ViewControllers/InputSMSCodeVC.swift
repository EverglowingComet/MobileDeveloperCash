//
//  InputSMSCodeVC.swift
//  MyStride
//
//  Created by KMHK on 7/11/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class InputSMSCodeVC: UIViewController {
	
	@IBOutlet weak var txtSMS: UITextField!
	@IBOutlet weak var btnContinue: UIButton!
	@IBOutlet weak var btnResend: UIButton!
	
	let utils = Utils.sharedInstance()
	let model = SignInUpModel.sharedInstance()
	

	// MARK: -
	
    override func viewDidLoad() {
        super.viewDidLoad()

		//set title view to navigation
		let _titleView = UILabel()
		_titleView.text = model.phoneNumber?.phoneNumFormat
		_titleView.font = utils.fontTitle
		_titleView.textColor =  utils.colorLightBk
		navigationItem.titleView = _titleView
		
		// set cancel button to navigation
		let _backView = UIButton(type: .system)
		_backView.setTitle(utils.localeString("Edit Number"), for: .normal)
		_backView.setTitleColor(utils.colorLightBk, for: .normal)
		_backView.titleLabel?.font = utils.fontButton
		_backView.addTarget(self, action: #selector(btnBackTapped(sender:)), for: .touchUpInside)
		let _back = UIBarButtonItem(customView: _backView)
		navigationItem.leftBarButtonItem = _back
		
		// customize note
		let _lblNote = view.viewWithTag(101) as! UILabel
		_lblNote.text = utils.localeString("Please enter your SMS code")
		_lblNote.font = utils.fontNote
		_lblNote.textColor = utils.colorGreyBk
		
		// set color to text view and buttons
		btnContinue.setTitle(utils.localeString("CONTINUE"), for: .normal)
		initButton(button: btnContinue, enable: false)
		
		btnResend.setTitle(utils.localeString("RESEND CODE"), for: .normal)
		initButton(button: btnResend, enable: false, type: 2)
		
		txtSMS?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: txtSMS.frame.size.height))
		initTextField(textField: txtSMS, flag: false)
		
		// add tap gesture
		view.addGestureRecognizer(UITapGestureRecognizer(target: self,
														 action: #selector(viewTapGesture(sender:))))
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
	
	
	func initButton(button: UIButton, enable: Bool, type: Int = 1) {
		button.layer.masksToBounds = true
		button.layer.cornerRadius = btnContinue.frame.size.height / 2
		button.titleLabel?.font = utils.fontButton
		
		if type == 1 {
			button.setTitleColor(utils.colorLightBk, for: .normal)
			button.backgroundColor = (enable == true) ? utils.colorBtn : utils.colorDisabledBk
			button.isEnabled = enable
			
		} else {
			button.layer.borderWidth = 3
			button.setTitleColor(utils.colorBtn, for: .normal)
			button.backgroundColor = utils.colorLightBk
			button.layer.borderColor = utils.colorBtn.cgColor
			button.isEnabled = true
		}
	}
	
	
	func hideProcessing(flag: Bool) {
		viewTapGesture(sender: self)
		
		UIView.animate(withDuration: 0.3) {
			self.btnContinue.alpha = (flag == false ? 1.0 : 0.0)
			self.btnResend.alpha = (flag == false ? 1.0 : 0.0)
		}
		
		if flag == false {
			WaitingView.hide()
			
		} else {
			WaitingView.show(view, type: .dark,
							 rect: CGRect(x: (view.frame.size.width - btnContinue.frame.size.height) / 2,
										  y:btnContinue.frame.origin.y,
										  width: btnContinue.frame.size.height, height: btnContinue.frame.size.height))
		}
	}
	
	
	// MARK: -
	
	@objc func btnBackTapped(sender: Any){
		navigationController?.popViewController(animated: true)
	}
	
	
	@objc func viewTapGesture(sender: Any) {
		txtSMS?.resignFirstResponder()
	}
	
	
	@IBAction func btnContinueTapped(_ sender: Any) {
		hideProcessing(flag: true)

		if model.isValidSMS(code: txtSMS.text!) {
			hideProcessing(flag: false)
			performSegue(withIdentifier: "segueNext", sender: nil)
			return
		}
		
		// show alert
		let alert = UIAlertController(title: utils.localeString("Invalid Code"),
									  message: utils.localeString("Please double-check the code and enter it again."),
									  preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: utils.localeString("OK"), style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
		
		hideProcessing(flag: false)
	}
    

	@IBAction func btnResendTapped(_ sender: Any) {
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
extension InputSMSCodeVC: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		// get new string
		let maxLength = 6
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		
		let tmp = (newString as String).replacingOccurrences(of: "-", with: "")
		
		if !tmp.isNumeric {
			return false
		}
		
		if tmp.count <= maxLength {
			txtSMS.text = tmp
		}
		
		// set text and button
		initTextField(textField: txtSMS, flag: (txtSMS.text != ""))
		initButton(button: btnContinue, enable: (txtSMS.text?.count == maxLength))
		
		return false
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		txtSMS.resignFirstResponder()
		
		return true
	}
}
