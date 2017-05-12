//
//  PhotoBrowserAnimator.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/11.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath: IndexPath) -> CGRect;
    func endRect(indexPath: IndexPath) -> CGRect;
    func imageView(indexPath: IndexPath) -> UIImageView;
}

class PhotoBrowserAnimator: NSObject {
    var isPresented: Bool = false
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            animationForPresentedView(transitionContext: transitionContext)
        } else {
            animationForDismissView(transitionContext: transitionContext)
        }
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 取出弹出的view
        let presentedView = transitionContext.view(forKey: .to)!
        // 将presentedView添加到contentView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.执行动画
        presentedView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
            presentedView.alpha = 1.0
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })

    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        // 取出消失的view
        let dismissView = transitionContext.view(forKey: .from)!
        
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView.alpha = 0.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}







