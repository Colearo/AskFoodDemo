//
//  VC1.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit

class VC1: UIViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.animation()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.animation()
    }
    func animation()
    {
        let labela=UILabel(frame: CGRectMake(60,300,50,50))
        let labelb=UILabel(frame: CGRectMake(160,300,50,50))
        let labelc=UILabel(frame: CGRectMake(260,300,50,50))
        labela.layer.backgroundColor=Color.green2.CGColor
        labela.layer.cornerRadius=25
        labelb.layer.backgroundColor=Color.blue.CGColor
        labelb.layer.cornerRadius=25
        labelc.layer.backgroundColor=Color.orange.CGColor
        labelc.layer.cornerRadius=25
        labela.alpha=0.0
        labelb.alpha=0.0
        labelc.alpha=0.0
        self.view.addSubview(labela)
        self.view.addSubview(labelb)
        self.view.addSubview(labelc)
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
            labela.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.5, options: .CurveLinear, animations: {
            labelb.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.9, options: .CurveLinear, animations: {
            labelc.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labela.center.y-=12
            }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.4, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labelb.center.y-=12
            }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.8, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labelc.center.y-=12
            }, completion: {
                finished in
                UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                    labela.center.x+=100
                    labelb.center.y-=100
                    }, completion: nil)
                UIView.animateWithDuration(0.6, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                    labela.center.y+=100
                    labelc.center.x-=100
                    }, completion: nil)
                let scale=CGAffineTransformMakeScale(8.0,8.0)
                UIView.animateWithDuration(1.5, delay: 1.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: .CurveLinear, animations: {
                    labela.layer.setAffineTransform(scale)
                    labelb.layer.setAffineTransform(scale)
                    labelc.layer.setAffineTransform(scale)
                    }, completion: {finished in
                        let label = UILabel(frame: CGRectMake(110,280,200,80))
                        label.alpha=0.0
                        label.textColor=Color.white
                        label.text="欢迎回来"
                        label.font=UIFont.systemFontOfSize(38)
                        self.view.addSubview(label)
                        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
                            label.alpha=1.0
                            }, completion: { finished in
                                currentChat.getVoice("欢迎回来",rates: 0.5)
                                self.performSegueWithIdentifier("s2", sender: nil)
                        })
                        
                })

        })
    }
}

