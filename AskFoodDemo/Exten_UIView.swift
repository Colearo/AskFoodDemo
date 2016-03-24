//
//  Exten_UIView.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
extension UIView {
    
    func width() ->CGFloat {
        return self.frame.size.width
    }
    
    func width(let width: CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func height() ->CGFloat {
        return self.frame.size.height
    }
    
    func height(let height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    func top()-> CGFloat {
        return self.frame.origin.y
    }
    
    func top(let top:CGFloat) {
        var rect:CGRect = self.frame
        rect.origin.y = top
        self.frame = rect
    }
    
    func bottom()-> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func bottom(bottom:CGFloat) {
        var rect:CGRect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
}
let kScreen_height: CGFloat = UIScreen.mainScreen().bounds.size.height
let kScreen_width: CGFloat = UIScreen.mainScreen().bounds.size.width
let kScreen_frame: CGRect = CGRectMake(0, 0, kScreen_width, kScreen_height)
extension String{
    func getLength()->Int{
        return (self as NSString).length
        
    }
    
}
