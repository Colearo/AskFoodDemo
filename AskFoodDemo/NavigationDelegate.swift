//
//  File.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch BtnNo {
        case 1:
            if operation == UINavigationControllerOperation.Push{
                return CircleTransitionAnimatorPushA()
                //return nil
            }
            return CircleTransitionAnimatorPopA()
            //return nil
        case 2:
            if operation == UINavigationControllerOperation.Push{
                return CircleTransitionAnimatorPushB()
            }
            return CircleTransitionAnimatorPopB()
            //return nil
        case 3:
            if operation == UINavigationControllerOperation.Push{
                return CircleTransitionAnimatorPushC()
            }
            return CircleTransitionAnimatorPopC()
        default:
            return nil
        }
    }
}
