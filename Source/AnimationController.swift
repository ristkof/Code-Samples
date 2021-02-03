//
//  GreenAnimationController.swift
//  Template
//
//  Created by Kristof Van Landschoot on 29/10/2020.
//  Copyright © 2020 Ristkof. All rights reserved.
//

import UIKit

class AnimationController: NSObject & UIViewControllerAnimatedTransitioning {
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
        let animatingSquareView = UIView(frame: redView.frame)
        animatingSquareView.backgroundColor = .red
        containerView.addSubview(animatingSquareView)
        let toVC = transitionContext.viewController(forKey: .to) as! ViewControllerGreen
        containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration) {
            animatingSquareView.backgroundColor = UIColor.green
            animatingSquareView.frame = toVC.greenView.frame
        } completion: { _ in
            self.redView.isHidden = false
            toVC.view.isHidden = false
            animatingSquareView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
