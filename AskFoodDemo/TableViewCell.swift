//
//  TableViewCell.swift
//  Ask Food
//
//  Created by Colearo on 16/1/26.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
class TableViewCell:UITableViewCell
{
    var customView:UIView!
    var bubbleImage:UIImageView!
    var avatarImage:UIImageView!
    var msgItem:MessageItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //- (void) setupInternalData
    init(data:MessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildUserInterface()
    }
    
    func rebuildUserInterface()
    {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        if (self.bubbleImage == nil)
        {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
        }
        
        let type =  self.msgItem.mtype
        let width =  self.msgItem.view.frame.size.width
        let height =  self.msgItem.view.frame.size.height
        self.backgroundColor=Color.clear
        var x =  (type == ChatType.Someone) ? 0 : self.frame.size.width - width - self.msgItem.insets.left - self.msgItem.insets.right-25
        var y:CGFloat =  0
        //if we have a chatUser show the avatar of the YDChatUser property
        if (self.msgItem.user.username != "")
        {
            
            let thisUser =  self.msgItem.user
            //self.avatarImage.removeFromSuperview()
            
            self.avatarImage = UIImageView(image:UIImage(named:(thisUser.avatar != "" ? thisUser.avatar : "You")))
            
            self.avatarImage.layer.cornerRadius = 15
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).CGColor
            self.avatarImage.layer.borderWidth = 1.0
            //calculate the x position
            
            let avatarX =  (type == ChatType.Someone) ? 2+10 : self.frame.size.width - 32 - 15
            print("avata:\(height)")
            let avatarY =  height
            //set the frame correctly
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 30, 30)
            print(self.avatarImage.frame )
            self.addSubview(self.avatarImage)
            
            let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height)
            print("delta:\(delta)")
            if (delta > 0)
            {
                y = delta
            }
            if (type == ChatType.Someone)
            {
                x += 44
                //backgroundColor = UIColor.blueColor()
            }
            if (type == ChatType.Mine)
            {
                x -= 34
                //backgroundColor = UIColor.redColor()
            }
        }
        print("Y:\(y)")
        //self.customView.removeFromSuperview()
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRectMake(x + self.msgItem.insets.left, y + self.msgItem.insets.top, width, height)
        self.customView.backgroundColor=Color.clear
        self.addSubview(self.customView)
        
        //depending on the ChatType a bubble image on the left or right
        if (type == ChatType.Someone)
        {
            //self.bubbleImage.image = UIImage(named:("yoububble.png"))!.stretchableImageWithLeftCapWidth(21,topCapHeight:14)
            self.bubbleImage.image = BubbleImage.incoming
            self.bubbleImage.highlightedImage = BubbleImage.incomingHighlighed
            
        }
        else {
            //self.bubbleImage.image = UIImage(named:"mebubble.png")!.stretchableImageWithLeftCapWidth(15, topCapHeight:14)
            self.bubbleImage.image = BubbleImage.outgoing
            self.bubbleImage.highlightedImage=BubbleImage.outgoingHighlighed
        }
        self.bubbleImage.frame = CGRectMake(x, y, width + self.msgItem.insets.left + self.msgItem.insets.right, height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImage.highlighted = selected
    }
}
let BubbleImage = bubbleImageMake()

func bubbleImageMake() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    let maskOutgoing = UIImage(named: "MessageBubble")!
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage!, scale: 2, orientation: .UpMirrored)
    
    //let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    //let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
    let incoming = coloredImage(maskIncoming, red: 229/255, green: 229/255, blue: 234/255, alpha: 1).stretchableImageWithLeftCapWidth(21,topCapHeight:14)
    let incomingHighlighted = coloredImage(maskIncoming, red: 206/255, green: 206/255, blue: 210/255, alpha: 1).stretchableImageWithLeftCapWidth(21,topCapHeight:14)
    let outgoing = coloredImage(maskOutgoing,red: 53/255, green: 160/255, blue: 146/255, alpha: 1.0).stretchableImageWithLeftCapWidth(15, topCapHeight:14)
    let outgoingHighlighted = coloredImage(maskOutgoing, red: 10/255, green: 110/255, blue: 90/255, alpha: 1).stretchableImageWithLeftCapWidth(15, topCapHeight:14)
    
    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}


