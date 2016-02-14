//
//  VC_c_s.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/31.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit

class VC_c_s: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let logos=UIImageView(image:UIImage(named:"logos"))
        let Studio_lab=UILabel(frame: CGRectMake(30,250,320,80))
        let Inf_lab=UILabel(frame: CGRectMake(30,350,320,150))
        logos.frame=CGRectMake(30,100,320,200)
        Studio_lab.textAlignment = .Center
        Studio_lab.text="LWG Studio"
        Studio_lab.textColor=Color.white
        Studio_lab.adjustsFontSizeToFitWidth = true
        Studio_lab.font = UIFont.systemFontOfSize(38)
        Inf_lab.text="这是我们小组开发的第一款基于移动端的智能健康助手应用，通过这款应用，您能够更有效地规划您的饮食，我们相信能够改善您的生活方式，如有建议和运行Bug，欢迎联系我们\n\tEmail：huhuhe@me.com"
        Inf_lab.textColor=Color.white
        Inf_lab.numberOfLines=0
        Inf_lab.lineBreakMode = .ByWordWrapping
        self.view.addSubview(logos)
        self.view.addSubview(Studio_lab)
        self.view.addSubview(Inf_lab)
    }

}
