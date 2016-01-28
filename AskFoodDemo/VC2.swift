//
//  VC2.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
var BtnNo=1
class VC2: UIViewController {
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBAction func ClickBtn1(sender: UIButton) {
        BtnNo=1
    }
    @IBAction func ClickBtn2(sender: UIButton) {
        BtnNo=2
    }
    @IBAction func ClickBtn3(sender: UIButton) {
        BtnNo=3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension CALayer {
    func setColorFromUIColor(color:UIColor)
    {
        self.borderColor=color.CGColor
    }
    func setShadowFromUIColor(color:UIColor)
    {
        self.shadowColor=color.CGColor
        self.shadowOffset=CGSizeMake(2.0, 2.0)
    }
    func setDefaultShadow()
    {
        self.shadowColor=Color.black.CGColor
        self.shadowOffset=CGSizeMake(2.0, 2.0)
        self.shadowOpacity=0.79
    }
}
