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
    @IBOutlet weak var navigationController: UINavigationController?
    var interactionController: UIPercentDrivenInteractiveTransition?
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let pan = UIPanGestureRecognizer(target: self, action: "panned:")
        self.navigationController!.view.addGestureRecognizer(pan)
    }
    @objc private func panned(gestureRecognizer: UIPanGestureRecognizer){
        switch gestureRecognizer.state {
        case .Began:
            self.interactionController = UIPercentDrivenInteractiveTransition()
            if self.navigationController?.viewControllers.count > 1 {
                self.navigationController?.popViewControllerAnimated(true)
            }
            else{
                //self.navigationController?.topViewController!.performSegueWithIdentifier("PushSegue", sender: nil)
            }
        case .Changed:
            let translation = gestureRecognizer.translationInView(self.navigationController!.view)
            let completionProgress = translation.x / CGRectGetWidth(self.navigationController!.view.bounds)
            self.interactionController?.updateInteractiveTransition(completionProgress)
        case .Ended:
            if gestureRecognizer.velocityInView(self.navigationController!.view).x > 0 {
                self.interactionController?.finishInteractiveTransition()
            }
            else{
                self.interactionController?.cancelInteractiveTransition()
            }
            self.interactionController = nil
        default:
            self.interactionController?.cancelInteractiveTransition()
            self.interactionController = nil
        }
    }
}
