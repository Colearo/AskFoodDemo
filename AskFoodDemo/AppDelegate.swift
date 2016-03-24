//
//  AppDelegate.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import SCLAlertView
let api_key = "4ef0963d04ca39f4292c1752994f09ca"
let api_url = "http://www.tuling123.com/openapi/api"
let userId = "colearo123"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 得到当前应用的版本号
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        let DayData = userDefaults.integerForKey("Day")
        let currentTime = userDefaults.valueForKey("currentTime")
        let date=NSDateFormatter()
        date.dateFormat = "yyMMdd"
        let stDay = Int(date.stringFromDate(NSDate()))
        currentChat = Chat()
        
         if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8 {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Badge, .Sound, .Alert], categories: nil))
        }
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion || DayData == 0 || currentTime == nil{
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            userDefaults.setValue(stDay!, forKey: "Day")
            userDefaults.setValue(stDay!, forKey: "openDay")
            userDefaults.setValue(currentChat.judgeTime().hashValue, forKey: "currentTime")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        //notification.fireDate = NSDate().dateByAddingTimeInterval(1)
        //setting timeZone as localTimeZone
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.repeatInterval = NSCalendarUnit.Calendar
        notification.alertTitle = "通知"
        notification.alertBody = "Hi 记得不要忘记吃一顿营养的晚餐哦"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        //setting app's icon badge
        notification.applicationIconBadgeNumber = 1
        
        var userInfo:[NSObject : AnyObject] = [NSObject : AnyObject]()
        userInfo["kLocalNotificationID"] = "LocalNotificationID"
        userInfo["key"] = "Attention Please"
        notification.userInfo = userInfo
        
        if currentChat.dateForm("HHmm") == "1704"
        {
            notification.alertBody = "Hi 记得不要忘记吃一顿营养的晚餐哦，顺便和AF君聊一聊"
            application.presentLocalNotificationNow(notification)
        }
        if currentChat.dateForm("HHmm") == "1204"
        {
            notification.alertBody = "记得和AF君聊聊你的午餐哦"
            application.presentLocalNotificationNow(notification)
        }
        if currentChat.dateForm("HHmm") == "0834"
        {
            notification.alertBody = "记得和AF君聊聊你的早餐吃了什么呢"
            application.presentLocalNotificationNow(notification)
        }
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.cancelAllLocalNotifications()
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
//        let userInfo = notification.userInfo!
//        let title = userInfo["key"] as! String
        
        SCLAlertView().showNotice(notification.alertTitle!, subTitle: "Hello Again！")
//        let alert = UIAlertView()
//        alert.title = title
//        alert.message = notification.alertBody
//        alert.addButtonWithTitle(notification.alertAction!)
//        alert.cancelButtonIndex = 0
//        alert.show()
        
        //APService.showLocalNotificationAtFront(notification, identifierKey: nil)
    }

}

