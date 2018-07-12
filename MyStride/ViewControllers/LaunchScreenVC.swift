//
//  LaunchScreenVC.swift
//  MyStride
//
//  Created by KMHK on 7/10/18.
//  Copyright © 2018 KmHk.Lu. All rights reserved.
//

import UIKit

class LaunchScreenVC: UIViewController {
	
	@IBOutlet weak var imgViewLogo: UIImageView!
	
	let utils = Utils.sharedInstance()
	
	
	// MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = utils.colorBk
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
