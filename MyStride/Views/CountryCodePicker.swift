//
//  CountryCodePicker.swift
//  MyStride
//
//  Created by KMHK on 7/11/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit


@objc public protocol CountryCodePickerDelegate {
	func countryCodePicker(_ picker: CountryCodePicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage)
	func countryCodePicker(_ picker: CountryCodePicker, didFinished finished: Bool)
}


// MARK: -

struct Country {
	var code: String?
	var name: String?
	var phoneCode: String?
	var flag: UIImage?

	init(code: String?, name: String?, phoneCode: String?, flag: UIImage?) {
		self.code = code
		self.name = name
		self.phoneCode = phoneCode
		self.flag = flag
	}
}


// MARK: -

open class CountryCodePicker: UIView {
	
	open weak var countryCodePickerDelegate: CountryCodePickerDelegate?
	
	open var showPhoneNumbers: Bool = true
	open var showFlags: Bool = false
	
	private var countries: [Country]!
	private var pickerView: UIPickerView?
	
	var colorToolBk: UIColor = UIColor.green
	var colorPickerBk: UIColor = UIColor.lightGray
	var colorPickerText: UIColor = UIColor.black
	
	var fontTool: UIFont = UIFont.systemFont(ofSize: 17.0)
	var fontPicker: UIFont = UIFont.systemFont(ofSize: 17.0)
	
	
	// MARK: ----- init method -----

	static func initPicker(frame: CGRect,
						   toolBk: UIColor = UIColor.green,
						   pickerBk: UIColor = UIColor.lightGray,
						   pickerTxt: UIColor = UIColor.black,
						   tool: UIFont = UIFont.systemFont(ofSize: 17.0),
						   picker: UIFont = UIFont.systemFont(ofSize: 17.0),
						   bShowPhoneNumber: Bool = true,
						   bShowFlag: Bool = false) -> CountryCodePicker {
		
		let _view = CountryCodePicker(frame: frame)
		
		_view.colorToolBk = toolBk
		_view.colorPickerBk = pickerBk
		_view.colorPickerText = pickerTxt
		
		_view.fontTool = tool
		_view.fontPicker = picker
		
		_view.showPhoneNumbers = bShowPhoneNumber
		_view.showFlags = bShowFlag
		
		_view.initPickerView()
		
		return _view
	}
	
	
	open func setCountryByPhoneCode(_ phoneCode: String) {
		guard let row = countries.index(where: {$0.phoneCode == phoneCode}) else { return }
		pickerView?.selectRow(row, inComponent: 0, animated: true)
		let country = countries[row]
		
		if let countryCodePickerDelegate = countryCodePickerDelegate {
			countryCodePickerDelegate.countryCodePicker(self, didSelectCountryWithName: country.name!, countryCode: country.code!, phoneCode: country.phoneCode!, flag: country.flag!)
		}
	}
	
	
	open func setCountry(_ code: String) {
		guard let row = countries.index(where: {$0.code == code}) else { return }
		pickerView?.selectRow(row, inComponent: 0, animated: true)
		let country = countries[row]
		
		if let countryCodePickerDelegate = countryCodePickerDelegate {
			countryCodePickerDelegate.countryCodePicker(self, didSelectCountryWithName: country.name!, countryCode: country.code!, phoneCode: country.phoneCode!, flag: country.flag!)
		}
	}
	
	
	// MARK: ----- private initialization -----
	
	private func initPickerView() {
		// read country prefix code
		countries = countryNamesByCode()
		
		pickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: frame.size.width, height: frame.size.height - 44))
		pickerView?.backgroundColor = colorPickerBk
		pickerView?.delegate = self
		pickerView?.dataSource = self
		addSubview(pickerView!)
		
		let _toolView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
		_toolView.backgroundColor = colorToolBk
		addSubview(_toolView)
		
		let _btnDone = UIButton(type: .system)
		_btnDone.frame = CGRect(x: (frame.size.width - 60) / 2, y: 0, width: 80, height: 44)
		_btnDone.setTitle("DONE", for: .normal)
		_btnDone.setTitleColor(UIColor.white, for: .normal)
		_btnDone.titleLabel?.font = fontTool
		_btnDone.addTarget(self, action: #selector(btnDoneTapped(sender:)), for: .touchUpInside)
		_toolView.addSubview(_btnDone)
	}
	
	
	private func countryNamesByCode() -> [Country] {
		var countries = [Country]()
		let frameworkBundle = Bundle(for: type(of: self))
		
		guard let jsonPath = frameworkBundle.path(forResource: "CountryPicker.bundle/Data/countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
			return countries
		}
		
		do {
			if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
				
				for jsonObject in jsonObjects {
					
					guard let countryObj = jsonObject as? NSDictionary else {
						return countries
					}
					
					guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
						return countries
					}
					
					let flag = UIImage(named: "CountryPicker.bundle/Images/\(code.uppercased())", in: Bundle(for: type(of: self)), compatibleWith: nil)
					
					let country = Country(code: code, name: name, phoneCode: phoneCode, flag: flag)
					countries.append(country)
				}
				
			}
		} catch {
			return countries
		}
		
		return countries
	}
	
	
	// MARK: ----- action implement -----
	
	@objc func btnDoneTapped(sender: Any) {
		if let countryCodePickerDelegate = countryCodePickerDelegate {
			countryCodePickerDelegate.countryCodePicker(self, didFinished: true)
		}
	}
}


// MARK: -

extension CountryCodePicker: UIPickerViewDelegate, UIPickerViewDataSource {
	open func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	
	open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return countries.count
	}
	
	
	open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 46
	}
	

	open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var _view = view
		if _view == nil {
			_view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 46))
			
			let lblName = UILabel(frame: CGRect(x: 20, y: 0, width: (_view?.frame.size.width)! - 75, height: (_view?.frame.size.height)!))
			lblName.textColor = colorPickerText
			lblName.font = fontPicker
			lblName.textAlignment = .left
			lblName.tag = 1000
			_view?.addSubview(lblName)
			
			let lblCode = UILabel(frame: CGRect(x: (_view?.frame.size.width)! - 75, y: 0, width: 55, height: (_view?.frame.size.height)!))
			lblCode.textColor = colorPickerText
			lblCode.font = fontPicker
			lblCode.textAlignment = .right
			lblCode.tag = 1001
			_view?.addSubview(lblCode)
		}
		
		(_view?.viewWithTag(1000) as? UILabel)?.text = countries[row].name
		(_view?.viewWithTag(1001) as? UILabel)?.text = countries[row].phoneCode?.replacingOccurrences(of: "+", with: "")
		
		return _view!
	}
	
	
	open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let country = countries[row]
		if let countryCodePickerDelegate = countryCodePickerDelegate {
			countryCodePickerDelegate.countryCodePicker(self, didSelectCountryWithName: country.name!, countryCode: country.code!, phoneCode: country.phoneCode!, flag: country.flag!)
		}
	}
	
}
