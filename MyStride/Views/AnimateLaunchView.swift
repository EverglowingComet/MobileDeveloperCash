//
//  AnimateLaunchView.swift
//  MyStride
//
//  Created by KMHK on 7/12/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class AnimateLaunchView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initView()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initView()
	}
	
	
	func initView() {
		backgroundColor = Utils.sharedInstance().colorBk
		
		let _imgView = UIImageView(frame: CGRect(x: (frame.size.width - 150)/2, y: (frame.size.height - 150)/2, width: 150, height: 150))
		_imgView.image = UIImage(named: "logo.png")
		_imgView.tag = 0x1000
		addSubview(_imgView)
		
		let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotationAnimation.fromValue = 0.0
		rotationAnimation.toValue = Float(Double.pi * 1.5)
		rotationAnimation.duration = 1.0
		rotationAnimation.repeatCount = 0
		rotationAnimation.delegate = self
		_imgView.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
	}
	
}


extension AnimateLaunchView: CAAnimationDelegate {
	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		viewWithTag(0x1000)?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1.5))
		
		UIView.animate(withDuration: 0.6, animations: {
			self.alpha = 0
		}, completion: { (finished) in
			self.removeFromSuperview()
		})
	}
}
