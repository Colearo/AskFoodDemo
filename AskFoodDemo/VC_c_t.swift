//
//  VC_c_t.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/3/23.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import SwiftForms
import Foundation
import Wilddog
import SCLAlertView

class VC_c_t: FormViewController {
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let gender = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
        static let age = "age"
        static let labourIntensity = "LabourIntensity"
        static let height = "height"
        static let weight = "weight"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .Plain, target: self, action: "submit:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "back:")
        self.view.backgroundColor = Color.orange
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues() as! Dictionary<String,AnyObject>
        print(message)
        let sentend = message[Static.labourIntensity]
        let myDataRef = myRootRef.childByAppendingPath("Profile")
        print(sentend)
        myDataRef.setValue(message)
        SCLAlertView().addButton("好的", action: {
            self.performSegueWithIdentifier("back", sender: nil)
        })
        SCLAlertView().showSuccess("修改成功", subTitle: "您已成功修改个人信息")
            
    }
    func back(_: UIBarButtonItem!) {
        BtnNo = 3
        //self.navigationController?.pushViewController(VC_c(), animated: true)
        self.performSegueWithIdentifier("back", sender: nil)
    }
    
    /// MARK: Private interface
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "个人信息"
        
        let section1 = FormSectionDescriptor()
        section1.headerTitle = "个人设置"
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "昵称")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "AF君", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        /*row = FormRowDescriptor(tag: Static.passwordTag, rowType: .Password, title: "密码")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter password", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.emailTag, rowType: .Email, title: "Email")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter Email", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        */
        
//        let section2 = FormSectionDescriptor()
//        
//        row = FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "First Name")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. Miguel Ángel", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section2.addRow(row)
//        
//        row = FormRowDescriptor(tag: Static.lastNameTag, rowType: .Name, title: "Last Name")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. Ortuño", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section2.addRow(row)
//        
//        row = FormRowDescriptor(tag: Static.jobTag, rowType: .Text, title: "Job")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. Entrepreneur", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section2.addRow(row)
//        
//        let section3 = FormSectionDescriptor()
//        
//        row = FormRowDescriptor(tag: Static.URLTag, rowType: .URL, title: "URL")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. gethooksapp.com", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section3.addRow(row)
//        let section2 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.age, rowType: .Phone, title: "年龄")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "18", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section2.addRow(row)
        
//        let section4 = FormSectionDescriptor()
//        
//        row = FormRowDescriptor(tag: Static.enabled, rowType: .BooleanSwitch, title: "Enable")
//        section4.addRow(row)
//        
//        row = FormRowDescriptor(tag: Static.check, rowType: .BooleanCheck, title: "Doable")
//        section4.addRow(row)
//        
//        row = FormRowDescriptor(tag: Static.segmented, rowType: .SegmentedControl, title: "Priority")
//        row.configuration[FormRowDescriptor.Configuration.Options] = [0...3]
//        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
//            switch( value ) {
//            case 0:
//                return "None"
//            case 1:
//                return "!"
//            case 2:
//                return "!!"
//            case 3:
//                return "!!!"
//            default:
//                return nil
//            }
//            } as TitleFormatterClosure
//        
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["titleLabel.font" : UIFont.boldSystemFontOfSize(30.0), "segmentedControl.tintColor" : UIColor.redColor()]
//        
//        section4.addRow(row)
        
//        section4.headerTitle = "An example header title"
//        section4.footerTitle = "An example footer title"
        
        let section3 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.gender, rowType: .Picker, title: "Gender")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["F", "M"]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case "F":
                return "女"
            case "M":
                return "男"
            default:
                return nil
            }
            } as TitleFormatterClosure
        
        row.value = "M"
        section3.addRow(row)
        
//        row = FormRowDescriptor(tag: Static.birthday, rowType: .Date, title: "生日")
//        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.age, rowType: .Phone, title: "年龄")
        row.value = 18
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.labourIntensity, rowType: .Picker, title: "劳动强度")
        row.configuration[FormRowDescriptor.Configuration.Options] = [0, 1 , 2]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case 0:
                return "低劳动强度"
            case 1:
                return "中劳动强度"
            case 2:
                return "高劳动强度"
            default:
                return nil
            }
            } as TitleFormatterClosure
        row.value = 1
        section3.addRow(row)
        
//        let section6 = FormSectionDescriptor()
//        section6.headerTitle = "Stepper & Slider"
//        
//        row = FormRowDescriptor(tag: Static.stepper, rowType: .Stepper, title: "Step count")
//        row.configuration[FormRowDescriptor.Configuration.MaximumValue] = 200.0
//        row.configuration[FormRowDescriptor.Configuration.MinimumValue] = 20.0
//        row.configuration[FormRowDescriptor.Configuration.Steps] = 2.0
//        section6.addRow(row)
//        
//        row = FormRowDescriptor(tag: Static.slider, rowType: .Slider, title: "Slider")
//        row.value = 0.5
//        section6.addRow(row)
//        
//        let section7 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.textView, rowType: .MultilineText, title: "Notes")
//        section7.headerTitle = "Multiline TextView"
//        section7.addRow(row)
//        
//        let section8 = FormSectionDescriptor()
//        
//        row = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Dismiss")
//        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
//            self.view.endEditing(true)
//            } as DidSelectClosure
//        section8.addRow(row)
        
        form.sections = [section1, section3]
        
        self.form = form
    }
}
