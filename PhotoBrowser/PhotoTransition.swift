//
//  PhotoTransition.swift
//  PhotoBrowser-swift
//
//  Created by zhangweiwei on 2017/1/20.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit

enum PhotoTransitionStyle {
    case present
    case dismiss
}

class PhotoTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    var style: PhotoTransitionStyle
    var animationDuration: TimeInterval = 0.5
    
    init(style: PhotoTransitionStyle) {
        self.style = style
        super.init()
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        switch style {
        case .present:
            
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! PhotoBrowser
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            
            if let sourceImageView = toVC.sourceImageView, let sourceImage = sourceImageView.image {
                
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = sourceImage
                imageView.frame = sourceImageView.superview?.convert(sourceImageView.frame, to: toVC.view) ?? CGRect.zero
                
                toVC.view.insertSubview(imageView, at: 1)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    
                    toVC.view.alpha = 1
                    imageView.frame = sourceImage.frameWithScreenWidth
                    
                }, completion: { (_) in
                    
                    imageView.removeFromSuperview()
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                })
            }else {
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
                    toVC.view.alpha = 1
                }, completion: { (_) in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            }
            
            
        case .dismiss:
            
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! PhotoBrowser
            
            if let sourceImageView = fromVC.sourceImageView, let displayImageView = fromVC.displayImageView {
                
                displayImageView.frame = displayImageView.superview?.convert(displayImageView.frame, to: containerView) ?? CGRect.zero
                containerView.addSubview(displayImageView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext) * 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    fromVC.view.alpha = 0
                    displayImageView.frame = sourceImageView.superview?.convert(sourceImageView.frame, to: containerView) ?? CGRect.zero
                    
                }, completion: { (_) in
                    
                    displayImageView.removeFromSuperview()
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            }else {
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromVC.view.alpha = 0
                }, completion: { (_) in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            }

            
            
            break
            
        }
        
    }

}
