//
//  VC3.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/3/21.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit

class VC3: UIViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.animation()
    }
    @IBAction func LoginTouch(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func SignTouch(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
