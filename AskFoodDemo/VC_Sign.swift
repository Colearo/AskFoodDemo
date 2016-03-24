//
//  VC_Sign.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/3/21.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import SCLAlertView
import Wilddog

class VC_Sign: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtPsd_confirm: UITextField!
    @IBOutlet weak var txtPsd_first: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var signLogo: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextfield()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func setupTextfield()
    {
        txtEmail.delegate = self
        txtPsd_first.delegate = self
        txtPsd_confirm.delegate = self
    }
    //设置关于键盘弹出和收回的相关代理
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                self.signLogo.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                self.txtEmail.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                self.txtPsd_first.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                self.txtPsd_confirm.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
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
                self.txtPsd_first.transform = CGAffineTransformIdentity
                self.txtPsd_confirm.transform = CGAffineTransformIdentity
                self.signLogo.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == txtEmail{ //如果用户名输入框点击换行就跳到密码输入框
            print("email!")
            textField.resignFirstResponder()
            txtPsd_first.becomeFirstResponder()
        }else if textField == txtPsd_first{//如果是密码输入框回车同时用户名完成输入，就进行登陆操作
            print("password first!")
            textField.resignFirstResponder()
            txtPsd_confirm.becomeFirstResponder()
            
        }else if textField == txtPsd_confirm && txtEmail.hasText() && txtPsd_first.hasText() && txtPsd_confirm.hasText(){
            print("password confirm")
            textField.resignFirstResponder()
            signupAction(self)
            
        }
        return true
    }
    @IBAction func signupAction(sender: AnyObject) {
        let email = self.txtEmail.text!
        let password = self.txtPsd_first.text!
        let passwordConfirm = self.txtPsd_confirm.text!
        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if email.getLength() < 8{
            SCLAlertView().showError("等一下...", subTitle:"请输入正确的电子邮箱地址", closeButtonTitle:"好的")
            return
        }
        else if password.getLength() <= 6{
            SCLAlertView().showError("等一下...", subTitle: "密码长度必须大于6个字符", closeButtonTitle:"好的")
            return
        }
        else if password != passwordConfirm{
            SCLAlertView().showError("等一下...", subTitle: "前后密码不匹配，请重新输入", closeButtonTitle:"好的")
            return
        }
        
        myRootRef.createUser(finalEmail, password: passwordConfirm, withCompletionBlock: {
            error in
            if error != nil{
                SCLAlertView().showError("错误...", subTitle: "注册时发生错误", closeButtonTitle: "")
            }
            else {
                let alert = SCLAlertView()
                alert.addButton("好的，现在登录", action: {
                    _ in
                    self.performSegueWithIdentifier("toLogin", sender: nil)
                })
                alert.showSuccess("注册成功", subTitle: "欢迎您成为Ask Food的一员")
            }
            }
        )
    }
    

}
