//
//  ViewController.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addFirstImageLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addFirstImageLabel()
    {
        let labelf=UILabel(frame: CGRectMake(50,230,280,140))
        let imageView=UIImageView(image:UIImage(named:"logo1"))
        let labels:UILabel=UILabel(frame: CGRectMake(400,404,120,35))
        let scale = CGAffineTransformMakeScale(1.5,3.0)
        labelf.backgroundColor=Color.green1
        labelf.alpha=0.0
        labels.text="LWG  Studio"
        labels.font=UIFont(name: "STHeitiJ-Light", size: 38)
        labels.textColor=Color.white
        imageView.frame=CGRectMake(30,200,320,200)
        //imageView.layer.shadowColor=Color.black.CGColor
        //imageView.layer.shadowOpacity=0.8
        //imageView.layer.shadowOffset=CGSize(width: 1, height: 1)
        self.view.addSubview(labelf)
        self.view.addSubview(labels)
        self.view.addSubview(imageView)
        UIView.animateWithDuration(0.3, delay: 0.2, options: .AllowAnimatedContent, animations: {
            imageView.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
            imageView.center.y -= 10
            }, completion: nil)
        UIView.animateWithDuration(0.8, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labels.alpha=1.0
            labels.center.x-=200
            labelf.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(1.5, delay: 1.6, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labelf.transform=scale
            }, completion: {finished in
                self.performSegueWithIdentifier("s1", sender: nil)
        })
    }


}

