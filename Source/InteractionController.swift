//
//  InteractionController.swift
//  Code Samples
//
//  Created by Kristof Van Landschoot on 03/02/2021.
//  Copyright © 2021 Ristkof. All rights reserved.
//

import UIKit

/// GreenToRedInterruptableController
class GreenToRedInterruptableController: NSObject, UIGestureRecognizerDelegate, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning
{
    private var transitionContext: UIViewControllerContextTransitioning?
    private weak var viewController: UIViewController?
    private var animator: UIViewPropertyAnimator?
    lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))

    init(_ vc: UIViewController) {
        viewController = vc
        super.init()
        panGestureRecognizer.delegate = self
    }
    
    deinit {
        NSLog("\(Self.description()) \(#function)")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        NSLog("\(Self.description()) \(#function)")
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        NSLog("\(Self.description()) \(#function)")
        return true
    }

    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        NSLog("\(#function) \(gestureRecognizer.state)")
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            NSLog("gestureRecognizer began")
            viewController?.dismiss(animated: true, completion: nil)
        case .changed:
            animator!.pauseAnimation()
            NSLog("gestureRecognizer changed \(progress)")
            animator!.fractionComplete = progress
        case .cancelled:
            NSLog("gestureRecognizer cancelled")
            transitionContext!.cancelInteractiveTransition()
        case .ended:
            animator!.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            transitionContext!.finishInteractiveTransition()
            NSLog("gestureRecognizer ended")
        default:
            break
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        NSLog("\(Self.description()) \(#function)")
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
        do {}   // nothing to do here
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        NSLog("\(Self.description()) \(#function)")
        self.transitionContext = transitionContext
        let greenVC = transitionContext.viewController(forKey: .from) as! ViewControllerGreen
        let redNC = transitionContext.viewController(forKey: .to) as! UINavigationController
        let redVC = redNC.viewControllers.compactMap { $0 as? ViewControllerRed }.first!
        let v = greenVC.greenView
        transitionContext.containerView.addSubview(v)
        v.constraints.forEach { $0.isActive = false }
        v.translatesAutoresizingMaskIntoConstraints = true
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
            v.frame = redVC.redView.frame
            v.backgroundColor = redVC.redView.backgroundColor
        }
        animator!.addCompletion { position in
            let completed = (position == .end)
            transitionContext.completeTransition(completed)
            v.removeFromSuperview()
        }
        animator!.startAnimation()
        return animator!
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
        do {}   // nothing to do here
    }
}
