//
//  VC_a.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import Wilddog
import SCLAlertView

var myRootRef = Wilddog(url:"https://askfood.wilddogio.com")
let dataRef = Wilddog(url: "https://askfood.wilddogio.com/Data")

var VC_A_Frame:CGRect?
var currentChat:Chat!

class VC_a: UIViewController,ChatDataSource,UITextFieldDelegate{
    var Chats:NSMutableArray!
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var textMsg:UITextField!
    var currentStr:String!
    var nextAction:EndType = EndType.NoEnd
    var sendView=UIView(frame: CGRect.zero)
    let btn1:UIButton=UIButton(frame: CGRectMake(100,600,70,30))
    let btn2:UIButton=UIButton(frame: CGRectMake(220,600,70,30))
    let btn3:UIButton=UIButton(frame: CGRect.zero)
    var count:Int=0
    @IBOutlet weak var Button: UIButton!
    @IBAction func ClickBtn(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func testJust(sender: UIButton) {
        //showEditer()
        self.showButton(["你好","hello"])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChatTable()
        self.setupSendPanel()
        self.setupKeyboard()
        self.setupButton()
        self.setupEditer()
        self.checkOnline()
        //self.showButton(["你好","hello"])
        //self.showEditer()
    }
    
    
    func setupModel()
    {
        print(currentChat.dateForm("yyMMdd"))
            //let chatRef = myRootRef.childByAppendingPath("Chat")
            //chatRef.setValue([String(NSUserDefaults.standardUserDefaults().integerForKey("Day")): [String(TimeDur.Night): false]])
        let currentRef = myRootRef.childByAppendingPath(currentChat.dateForm("yyMMdd"))
        currentRef.observeSingleEventOfType(.Value, withBlock: {
            snap in
            if snap.hasChildren() != true
            {
                currentRef.setValue([String(TimeDur.Morning): ["isAsked" : false,"contextTag": ""],String(TimeDur.Noon): ["isAsked" : false,"contextTag": ""],String(TimeDur.Night): ["isAsked" : false,"contextTag": ""],"EER": 0,"PRO": 0,"Vc": 0])
            }
        })
        
        //currentRef.observeEventType(.ChildChanged, withBlock: {
        //    snap in
        //    print(snap.value.objectForKey("contextTag"))
        //})
        
        
        var ret = currentChat.getReturned(currentStr, type: QuestionType.Greet)
        
        if nextAction == EndType.GreetEnd {
            ret = currentChat.getReturned(currentStr,type: QuestionType.Food)
        }
        if nextAction == EndType.FoodEnd{
            ret = currentChat.getReturned(currentStr,type: QuestionType.SmaTalk)
        }
        if nextAction == EndType.AllEnd{
            currentChat.getVoice(currentStr,rates: 0.4)
            self.showEditer()
            return
        }
        nextAction = ret.typeEnd
        switch ret.returnsty
            {
            case .Text :
                if ret.image != nil
                {
                    Chats.addObject(ret.image!)
                }
                for strItem in ret.strings
                {
                    let item = MessageItem(body: strItem, user: you, date: NSDate(), mtype: ChatType.Someone)
                    Chats.addObject(item)
                }
                self.tableView.reloadData()
                self.animationLoad()
            case .Input :
                self.showEditer()
            case .Button :
                self.showButton(ret.strings)
            }
        
    }
    
   
    func checkOnline()
    {
        let connectedRef = Wilddog(url:"https://askfood.wilddogio.com/.info/connected")
        connectedRef.observeEventType(.Value, withBlock: { snapshot in
            let connected = snapshot.value as? Bool
            if connected != nil && connected! {
                print("connected")
            } else {
                SCLAlertView().showNotice("注意", subTitle: "连接已经断开", closeButtonTitle: "确定")
                print("not connected")
            }
        })
    }
    
    
    func setupChatTable()
    {
        self.tableView = TableView(frame:CGRectMake(30, 100, self.view.frame.size.width-60, self.view.frame.size.height-170), style:.Plain)
        self.tableView.layer.cornerRadius=10
        tableView.backgroundColor=Color.white
        //创建一个重用的单元格
        self.tableView!.registerClass(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        
        
        me = UserInfo(name:"大C" ,logo:("Me"))
        you  = UserInfo(name:"Ask君", logo:("You"))
        
        
        //let first =  MessageItem(body:"嘿，这张照片咋样，我在泸沽湖拍的呢！红红火火恍恍惚惚红红火火", user:me,  date:NSDate(timeIntervalSinceNow:-600), mtype:ChatType.Mine)
        
        //let second =  MessageItem(image:UIImage(named:"button1")!,user:me, date:NSDate(timeIntervalSinceNow:-290), mtype:ChatType.Mine)
        
        Chats = NSMutableArray()
        
        currentChat = Chat()
        currentStr = ""
        let zero =  MessageItem(body:currentChat.getReturned(type: QuestionType.Greet).strings[0], user:you,  date:NSDate(), mtype:ChatType.Someone)
        Chats.addObject(zero)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
        self.animationLoad()
    }
    
    
    
    func setupSendPanel()
    {
        sendView = UIView(frame:CGRectMake(30,self.view.frame.size.height - 50,self.view.frame.size.width-60,50))
        sendView.center.y=700
        
        sendView.backgroundColor=Color.clear
        sendView.alpha=0.79
        
        textMsg = UITextField(frame:CGRectMake(7,10,225,36))
        textMsg.backgroundColor = Color.green2
        textMsg.alpha=0.79
        textMsg.textColor=Color.white
        textMsg.font=UIFont.boldSystemFontOfSize(12)
        textMsg.layer.cornerRadius = 10.0
        textMsg.returnKeyType = UIReturnKeyType.Send
        textMsg.clearButtonMode=UITextFieldViewMode.WhileEditing
        
        //Set the delegate so you can respond to user input
        textMsg.delegate=self
        sendView.addSubview(textMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton(frame:CGRectMake(240,10,72,36))
        sendButton.backgroundColor=textMsg.backgroundColor
        sendButton.addTarget(self, action:Selector("sendMessage") ,forControlEvents:UIControlEvents.TouchUpInside)
        sendButton.layer.cornerRadius=9.0
        sendButton.setTitle("发送", forState:UIControlState.Normal)
        sendView.addSubview(sendButton)
    }
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    func sendMessage()
    {
        //composing=false
        let sender = textMsg
        currentStr = sender.text!
        
        let thisChat =  MessageItem(body:sender.text!, user:me, date:NSDate(), mtype:ChatType.Mine)
        
        Chats.addObject(thisChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        if nextAction == .AllEnd
        {
            Alamofire.request(.POST, NSURL(string: api_url)!, parameters: ["key":api_key,"info":currentStr,"userid":userId])
                .responseJSON(options: NSJSONReadingOptions.MutableContainers) { response   in
                    
                    let data = response.result
                    guard data.isSuccess else{
                        print("Data read error \(data.error)")
                        return
                    }
                    
                    guard let text = data.value!.objectForKey("text") as? String else{
                        print("Text is nil!")
                        return
                    }
                    print(text)
                    let thatChat = MessageItem(body: text, user: self.you, date: NSDate(), mtype: ChatType.Someone)
                    self.Chats.addObject(thatChat)
                    self.tableView.reloadData()
                    self.animationLoad()
            }
            sender.resignFirstResponder()
            sender.text = ""
            return
        }
        self.animationLoad()

        sender.resignFirstResponder()
        sender.text = ""
    }
    
    
    func setupKeyboard()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    func keyboardWillChange(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        
        if endFrame?.origin.y == kScreen_height {
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                self.sendView.frame.origin.y = kScreen_height
                self.sendView.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                self.sendView.alpha = 1
                self.sendView.bottom(kScreen_height - (endFrame?.height)!)
            })
        }
    }
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height-120
        
        //根据键盘高度设置Inset
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        // 优化，防止键盘消失后tableview有跳跃
        if self.tableView.tracking || self.tableView.decelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }
    
    
    //弹出按钮的初始化设置
    func setupButton()
    {
        VC_A_Frame = self.Button.frame
        
        
        btn1.backgroundColor=Color.green2
        btn1.alpha=0.69
        btn1.tintColor=Color.white
        btn1.setTitleColor(Color.white, forState: .Normal)
        
        
        btn2.backgroundColor=Color.green2
        btn2.alpha=0.69
        btn2.tintColor=Color.white
        btn2.setTitleColor(Color.white, forState: .Normal)
        
        
        btn1.addTarget(self, action:Selector("sendButton:") ,forControlEvents:.TouchUpInside)
        btn2.addTarget(self, action: Selector("sendButton:"), forControlEvents: .TouchUpInside)
    }
    //弹出按钮动画
    func showButton(choice:[String])
    {
        count++
        btn1.center.y=700
        btn2.center.y=700
        self.view.addSubview(btn1)
        self.view.addSubview(btn2)
        btn1.setTitle( "  "+choice[0]+"  ", forState: .Normal)
        btn2.setTitle("  "+choice[1]+"  ", forState: .Normal)
        btn2.sizeToFit()
        btn1.sizeToFit()
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.AllowUserInteraction,.CurveLinear], animations: {
            self.btn1.center.y-=65
            self.btn2.center.y-=65
            }, completion:nil)
    }
    func sendButton(button:UIButton)
    {
        let temp=button
        currentStr = button.titleForState(.Normal)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let last=MessageItem(body:temp.titleForState(.Normal)!,user:me, date:NSDate(), mtype:ChatType.Mine)
        Chats.addObject(last)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.AllowUserInteraction,.CurveLinear], animations: {
            self.btn1.center.y+=120
            self.btn2.center.y+=120
            }, completion: {finished in
                //let make=MessageItem(body:"哈哈",user:self.you, date:NSDate(), mtype:.Someone)
                //self.Chats.addObject(make)
                self.animationLoad()
                self.btn1.removeFromSuperview()
                self.btn2.removeFromSuperview()
        })
    }
    
    
    //加载动画
    func animationLoad()
    {
        let labela=UILabel(frame: CGRectMake(100,300,25,25))
        let labelb=UILabel(frame: CGRectMake(160,300,25,25))
        let labelc=UILabel(frame: CGRectMake(220,300,25,25))
        labela.frame=CGRectMake(60,300,50,50)
        labelb.frame=CGRectMake(160,300,50,50)
        labelc.frame=CGRectMake(260,300,50,50)
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
        currentChat.getVoice(currentStr,rates: 0.4)
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveLinear, animations: {
            labela.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(0.1, delay: 0.4, options: .CurveLinear, animations: {
            labelb.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(0.1, delay: 0.8, options: .CurveLinear, animations: {
            labelc.alpha=1.0
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labela.center.y-=8
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labelb.center.y-=8
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.7, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [.AllowUserInteraction,.CurveEaseInOut], animations: {
            labelc.center.y-=8
            }, completion: { finished in
                self.setupModel()
                /*switch self.count{
                case 1:
                    self.Chats.addObject(one)
                    self.tableView.reloadData()
                    self.showButton(["嗯","没有💢"])
                case 2:
                    self.showEditer()
                case 3:
                    self.Chats.addObject(two)
                    self.Chats.addObject(imaget)
                    self.Chats.addObject(three)
                    self.tableView.reloadData()
                    self.showButton(["OK","为什么呢"])
                default:
                    self.showButton(["你好","晚上好"])
                }*/
                //self.tableView.reloadData()
                labela.removeFromSuperview()
                labelb.removeFromSuperview()
                labelc.removeFromSuperview()
        })
    }
    
    
    func setupEditer()
    {
        btn3.center.x=120
        btn3.sizeToFit()
        btn3.backgroundColor=Color.green2
        btn3.alpha=0.69
        btn3.tintColor=Color.white
        btn3.setTitleColor(Color.white, forState: .Normal)
        btn3.setTitle("  现在输入信息  ", forState: .Normal)
        btn3.addTarget(self, action:Selector("clickEditer:") ,forControlEvents:.TouchUpInside)
    }
    func showEditer()
    {
        count++
        btn3.center.y=700
        btn3.sizeToFit()
        self.view.addSubview(btn3)
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.AllowUserInteraction,.CurveLinear], animations: {
            self.btn3.center.y-=70
            }, completion:nil)
    }
    func clickEditer(sender:UIButton)
    {
        
        UIView.animateWithDuration(0.15, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.AllowUserInteraction,.CurveLinear], animations: {
            self.btn3.center.y+=100
            }, completion:{finished in
                self.btn3.removeFromSuperview()
                self.textMsg.becomeFirstResponder()
        })
    }
    
    
    func rowsForChatTable(tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
}
