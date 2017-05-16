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

protocol AnimatorDismissedDelegate : NSObjectProtocol {
    func indexPathForDismissView() -> IndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented: Bool = false
    
    var presentedDelegate : AnimatorPresentedDelegate?
    var dismissDelegate : AnimatorDismissedDelegate?
    var indexPath: IndexPath?
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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            animationForPresentedView(transitionContext: transitionContext)
        } else {
            animationForDismissView(transitionContext: transitionContext)
        }
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 校验nil值
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        // 取出弹出的view
        let presentedView = transitionContext.view(forKey: .to)!
        // 将presentedView添加到contentView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        // 3.执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
        }, completion: { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        })

    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        // nil校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        // 取出消失的view
        let dismissView = transitionContext.view(forKey: .from)!
        dismissView.removeFromSuperview()
        
        //获取执行动画的imageView
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismissView()
        
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}







