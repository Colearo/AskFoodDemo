//
//  MessageItem.swift
//  Ask Food
//
//  Created by Colearo on 16/1/26.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit

//消息类型，我的还是别人的
enum ChatType {
    case Mine
    case Someone
}
/*
用户信息类
*/
class UserInfo:NSObject
{
    var username:String = ""
    var avatar:String = ""
    
    init(name:String, logo:String)
    {
        self.username = name
        self.avatar = logo
    }
}
class MessageItem {
    var user:UserInfo
    var date:NSDate
    var mtype:ChatType
    var view:UIView
    var insets:UIEdgeInsets
    
    
    class func getTextInsetsMine() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:5, left:10, bottom:11, right:17)
    }
    
    class func getTextInsetsSomeone() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:5, left:15, bottom:11, right:10)
    }
    class func getImageInsetsMine() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    class func getImageInsetsSomeone() -> UIEdgeInsets
    {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    
    init(user:UserInfo, date:NSDate, mtype:ChatType, view:UIView, insets:UIEdgeInsets)
    {
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
    
    //文字类型消息
    convenience init(body:NSString, user:UserInfo, date:NSDate, mtype:ChatType)
    {
        let font =  UIFont.boldSystemFontOfSize(12)
        
        let width =  150, height = 10000.0
        
        let atts =  [NSFontAttributeName: font]
        
        let size =  body.boundingRectWithSize(CGSizeMake(CGFloat(width), CGFloat(height))  ,     options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:atts ,     context:nil)
        
        let label =  UILabel(frame:CGRectMake(0, 0, size.size.width, size.size.height))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = (body.length != 0 ? body as String : " ")
        label.font = font
        label.backgroundColor = UIColor.clearColor()
        label.textColor=(mtype==ChatType.Mine ? UIColor.whiteColor() : UIColor.blackColor())
        
        let insets:UIEdgeInsets =  (mtype == ChatType.Mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets)
    }
    
    //图片类型消息
    convenience init(image:UIImage, user:UserInfo,  date:NSDate, mtype:ChatType)
    {
        var size = image.size
        //等比缩放
        if (size.width > 140)
        {
            size.height /= (size.width / 140);
            size.width = 140;
        }
        let imageView = UIImageView(frame:CGRectMake(0, 0, size.width, size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == ChatType.Mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user:user,  date:date, mtype:mtype, view:imageView, insets:insets)
    }
}