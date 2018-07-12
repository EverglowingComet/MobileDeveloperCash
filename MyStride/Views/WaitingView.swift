//
//  WaitingView.swift
//  MyStride
//
//  Created by KMHK on 7/11/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

var gWaitingView: WaitingView?


enum WaitingViewType {
	case dark;
	case white;
}


class WaitingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	static func show(_ toView: UIView, type: WaitingViewType = .dark, rect: CGRect = CGRect.zero) {
		let _rect = CGRect(x: (toView.frame.size.width - 40) / 2, y: (toView.frame.size.height - 40) / 2, width: 44, height: 44)
		if gWaitingView == nil {
			gWaitingView = WaitingView(frame: (rect == CGRect.zero) ? _rect : rect)
		}
		
		gWaitingView?.removeFromSuperview()
		
		gWaitingView?.initWaitingView()
		gWaitingView?.frame = (rect == CGRect.zero) ? _rect : rect
		
		(gWaitingView?.viewWithTag(0x1000) as! UIImageView).image = UIImage(named: (type == .dark) ? "waitingIco.png" : "waitingIco_white.png")
		toView.addSubview(gWaitingView!)
		
		gWaitingView?.alpha = 0.0
		UIView.animate(withDuration: 0.3) {
			gWaitingView?.alpha  = 1.0
		}
	}
	
	static func hide() {
		if let _waitingView = gWaitingView {
			UIView.animate(withDuration: 0.3, animations: {
				_waitingView.alpha = 0.0
			}) { (finished) in
				_waitingView.removeFromSuperview()
			}
		}
	}

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initWaitingView()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initWaitingView()
	}
	
	
	func initWaitingView() {
		var _imgView: UIImageView? = viewWithTag(0x1000) as! UIImageView?
		
		if _imgView == nil {
			_imgView = UIImageView(frame: self.bounds)
			_imgView?.tag = 0x1000
			addSubview(_imgView!)
		}
		
		let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotationAnimation.fromValue = 0.0
		rotationAnimation.toValue = Float(Double.pi * 2.0)
		rotationAnimation.duration = 0.6
		rotationAnimation.repeatCount = Float.infinity
		_imgView?.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
	}
}
