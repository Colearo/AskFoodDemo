//
//  VC_Login.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/3/21.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import SCLAlertView
import Wilddog

class VC_Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginLogo: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfield()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func setupTextfield()
    {
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPassword.secureTextEntry = true
    }
    //设置关于键盘弹出和收回的相关代理
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                self.loginLogo.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                self.txtEmail.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                self.txtPassword.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                }, completion: nil)
        }
        
    }
    func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                self.txtEmail.transform = CGAffineTransformIdentity
                self.txtPassword.transform = CGAffineTransformIdentity
                self.loginLogo.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == txtEmail{ //如果用户名输入框点击换行就跳到密码输入框
            print("email!")
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }else if textField == txtPassword && txtEmail.hasText() && txtPassword.hasText(){
            print("password!")
            textField.resignFirstResponder()
            loginAction(self)
        }
        return true
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        let email = self.txtEmail.text
        let password = self.txtPassword.text
        
        if email == nil || password == nil
        {
            SCLAlertView().showError("等一下...", subTitle:"不存在此电子邮件或密码不正确", closeButtonTitle:"好的")
            return
        }
        
        myRootRef.authUser(email, password: password, withCompletionBlock: {
            error,authData in
            if (error != nil) {
                // 在登录时发生错误
                SCLAlertView().showError("等一下...", subTitle:"不存在此电子邮件或密码不正确", closeButtonTitle:"好的")
                return
            } else {
                // 登录成功
                let alert = SCLAlertView()
                alert.addButton("进入Ask Food", action: {
                    _ in
                    myRootRef = myRootRef.childByAppendingPath("User").childByAppendingPath(authData.uid)
                    let currentRef = myRootRef.childByAppendingPath(currentChat.dateForm("yyMMdd"))
                    currentRef.observeSingleEventOfType(.Value, withBlock: {
                        snap in
                        if snap.hasChildren() != true
                        {
                            currentRef.setValue([String(TimeDur.Morning): ["isAsked" : false,"contextTag": ""],String(TimeDur.Noon): ["isAsked" : false,"contextTag": ""],String(TimeDur.Night): ["isAsked" : false,"contextTag": ""],"EER": 0,"PRO": 0,"Vc": 0])
                        }
                    })
                    self.performSegueWithIdentifier("s1", sender: nil)
                })
                alert.showSuccess("登录成功", subTitle: "请享受美好的一天吧")
            }
        })
    }

    
}
