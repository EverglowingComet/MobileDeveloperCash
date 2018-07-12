//
//  SignupNavVC.swift
//  MyStride
//
//  Created by KMHK on 7/10/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class SignupNavVC: UINavigationController {
	
	let utils = Utils.sharedInstance()
	
	// MARK: -
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		navigationBar.barTintColor = utils.colorBk;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func show(_ vc: UIViewController, sender: Any?) {
		super.show(vc, sender: sender)
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
