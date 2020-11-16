//
//  GreenAnimationController.swift
//  Template
//
//  Created by Kristof Van Landschoot on 29/10/2020.
//  Copyright © 2020 Ristkof. All rights reserved.
//

import UIKit

class GreenAnimationController: NSObject & UIViewControllerAnimatedTransitioning {
    let redView: UIView
    
    init(_ rv: UIView) {
        redView = rv
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        redView.isHidden = true
        let v = UIView(frame: redView.frame)
        v.backgroundColor = .red
        containerView.addSubview(v)
        let toVC = transitionContext.viewController(forKey: .to) as! ViewControllerGreen
        containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration) {
            v.backgroundColor = UIColor.green
            v.frame = toVC.greenView.frame
        } completion: { _ in
            self.redView.isHidden = false
            toVC.view.isHidden = false
            v.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
