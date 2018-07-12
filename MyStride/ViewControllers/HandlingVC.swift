//
//  HandlingVC.swift
//  MyStride
//
//  Created by KMHK on 7/12/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class HandlingVC: UIViewController {

	@IBOutlet weak var txtHandle: UITextField!
	@IBOutlet weak var btnContinue: UIButton!
	@IBOutlet weak var lblWarning: UILabel!
	
	let utils = Utils.sharedInstance()
	let model = SignInUpModel.sharedInstance()
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		//set title view to navigation
		let _titleView = UILabel()
		_titleView.text = utils.localeString("Handle")
		_titleView.font = utils.fontTitle
		_titleView.textColor =  utils.colorLightBk
		navigationItem.titleView = _titleView
		
		// set cancel button to navigation
		navigationItem.hidesBackButton = true
		
		// customize note
		let _lblNote = view.viewWithTag(101) as! UILabel
		_lblNote.text = utils.localeString("Handle is your unique 5 to 20 chracter identity")
		_lblNote.font = utils.fontNote
		_lblNote.textColor = utils.colorGreyBk
		
		_lblNote.font = utils.fontNote
		_lblNote.textColor = utils.colorAlert
		
		// set color to text view and buttons
		btnContinue.setTitle(utils.localeString("CONTINUE"), for: .normal)
		initButton(button: btnContinue, enable: false)
		
		txtHandle?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: txtHandle.frame.size.height))
		initTextField(textField: txtHandle, flag: false)
		
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
	
	
	// MARK: -
	
	@objc func btnBackTapped(sender: Any){
		navigationController?.popViewController(animated: true)
	}
	
	
	@objc func viewTapGesture(sender: Any) {
		txtHandle?.resignFirstResponder()
	}
	
	
	@IBAction func btnContinueTapped(_ sender: Any) {
//		hideProcessing(flag: true)
//
//		if model.isValidSMS(code: txtSMS.text!) {
//			hideProcessing(flag: false)
//			performSegue(withIdentifier: "segueNext", sender: nil)
//			return
//		}
//
//		// show alert
//		let alert = UIAlertController(title: utils.localeString("Invalid Code"),
//									  message: utils.localeString("Please double-check the code and enter it again."),
//									  preferredStyle: .alert)
//		alert.addAction(UIAlertAction(title: utils.localeString("OK"), style: .cancel, handler: nil))
//		present(alert, animated: true) {
//			self.hideProcessing(flag: false)
//		}
	}
	
	
	// MARK: -
	
	func isValidHandle(str: String){
		
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
extension HandlingVC: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		// get new string
		let maxLength = 20
		let minLength = 5
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		
		if (newString as String).count <= maxLength {
			txtHandle.text = newString as String
		}
		
		isValidHandle(str: txtHandle.text!)
		
		// set text and button
		initTextField(textField: txtHandle, flag: (txtHandle.text != ""))
		initButton(button: btnContinue, enable: ((txtHandle.text?.count)! >= minLength))
		
		return false
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		txtHandle.resignFirstResponder()
		
		return true
	}
}
