//
//  VC_c.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit

class VC_c: UIViewController {
    @IBOutlet weak var Button: UIButton!
    @IBAction func ClickBtn(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
