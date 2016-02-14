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
        BtnNo=3
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        BtnNo=0
        let logos=UIImageView(image:UIImage(named:"logos"))
        let Inf_btn=UIButton(frame: CGRectMake(30,300,320,50))
        let About_btn=UIButton(frame: CGRectMake(30,355,320,50))
        logos.frame=CGRectMake(30,100,320,200)
        Inf_btn.layer.cornerRadius=10
        Inf_btn.layer.borderColor=Color.white.CGColor
        Inf_btn.layer.borderWidth=1.5
        Inf_btn.setTitle("个人信息", forState: .Normal)
        Inf_btn.setTitleColor(Color.white, forState: .Normal)
        Inf_btn.setTitleColor(Color.orange, forState: .Highlighted)
        About_btn.layer.cornerRadius=10
        About_btn.layer.borderColor=Color.white.CGColor
        About_btn.layer.borderWidth=1.5
        About_btn.setTitle("关于我们", forState: .Normal)
        About_btn.setTitleColor(Color.white, forState: .Normal)
        About_btn.setTitleColor(Color.orange, forState: .Highlighted)
        About_btn.addTarget(self, action: Selector("toAbout") , forControlEvents: .TouchUpInside)
        self.view.addSubview(logos)
        self.view.addSubview(Inf_btn)
        self.view.addSubview(About_btn)
    }
    func toAbout()
    {
        let vc = VC_c_s()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
