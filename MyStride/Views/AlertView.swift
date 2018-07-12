//
//  AlertView.swift
//  MyStride
//
//  Created by KMHK on 7/11/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

var gAlertView: AlertView?


enum AlertViewType {
	case error;
	case warning;
}

class AlertView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	static func show(_ toView: UIView, type: AlertViewType = .error, pos: CGPoint = CGPoint.zero) {
		if gAlertView == nil {
			gAlertView = AlertView(frame: CGRect(x: pos.x, y: pos.y, width: toView.frame.size.width, height: 29 + pos.y))
			gAlertView?.initAlertView(type: type)
		}
		
		gAlertView?.removeFromSuperview()
		
		toView.addSubview(gAlertView!)
		
		gAlertView?.frame = CGRect(x: 0, y: -(gAlertView?.frame.size.height)!, width: (gAlertView?.frame.size.width)!, height: (gAlertView?.frame.size.height)!)
		
		UIView.animate(withDuration: 0.3, animations: {
			gAlertView?.frame = CGRect(x: 0, y: 0, width: (gAlertView?.frame.size.width)!, height: (gAlertView?.frame.size.height)!)
			
		}) { (finished) in
			
			UIView.animate(withDuration: 0.3, delay: 2.0, options: .beginFromCurrentState, animations: {
				gAlertView?.frame = CGRect(x: 0, y: -(gAlertView?.frame.size.height)!, width: (gAlertView?.frame.size.width)!, height: (gAlertView?.frame.size.height)!)
			}, completion: { (finished) in
				gAlertView?.removeFromSuperview()
			})
		}
	}
	
	
	func initAlertView(type: AlertViewType) {
		backgroundColor = (type == .error) ? Utils.sharedInstance().colorAlert : Utils.sharedInstance().colorGreyBk
		
		let _lblNote = UILabel(frame: CGRect(x: 0, y: frame.size.height - 29, width: frame.size.width, height: 29))
		_lblNote.textColor = Utils.sharedInstance().colorLightBk
		_lblNote.font = Utils.sharedInstance().fontNote
		_lblNote.textAlignment = .center
		_lblNote.text = (type == .error) ? Utils.sharedInstance().localeString("Please check that your number is 10 digits") : Utils.sharedInstance().localeString("No Internet Connection")
		addSubview(_lblNote)
		
		let _imgView = UIImageView(image: UIImage(named: (type == .error) ? "xIco.png" : "warningIco.png"))
		_imgView.contentMode = .scaleAspectFill
		let _rt = (_lblNote.text! as NSString).boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : _lblNote.font], context: nil)
		_imgView.frame = CGRect(x: (frame.size.width - _rt.size.width) / 2 - 16 - 15, y: (frame.size.height - _lblNote.frame.origin.y - 15) / 2 + _lblNote.frame.origin.y, width: 15, height: 15)
		addSubview(_imgView)
	}
	
}
