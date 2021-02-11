//
//  InteractionController.swift
//  Code Samples
//
//  Created by Kristof Van Landschoot on 03/02/2021.
//  Copyright © 2021 Ristkof. All rights reserved.
//

import UIKit

/// GreenToRedInterruptableController
///
/// Partly based on GuessThePet code on github here https://github.com/xuzhengquan/GuessThePet
/// the original code works but was quite chunky in its animations and has no explanations
/// Partly based on PullToDismissTransition by Ben Guild, but that worked only interactively
/// and we want to have interactive **and** programmatic (triggered from button)
class GreenToRedInterruptableController: NSObject, UIGestureRecognizerDelegate, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning
{
    private var transitionContext: UIViewControllerContextTransitioning?
    private var shouldCompleteTransition = false
    private var _wantsInteractiveStart = false
    private weak var viewController: UIViewController?
    private var animator: UIViewPropertyAnimator?
    lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))

    init(_ vc: UIViewController) {
        viewController = vc
        super.init()
        panGestureRecognizer.delegate = self
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
            _wantsInteractiveStart = true
        case .changed:
            NSLog("gestureRecognizer changed \(progress)")
            shouldCompleteTransition = progress > 0.5
            animator!.fractionComplete = progress
        case .cancelled:
            NSLog("gestureRecognizer cancelled")
            transitionContext!.cancelInteractiveTransition()
            _wantsInteractiveStart = false
        case .ended:
            animator!.continueAnimation(withTimingParameters: nil, durationFactor: 2)
            transitionContext!.finishInteractiveTransition()
            _wantsInteractiveStart = false
            NSLog("gestureRecognizer ended")
        default:
            break
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        NSLog("\(Self.description()) \(#function)")
        return 2
    }

    private func createAnimationIfItDoesNotExistYet(_ transitionContext: UIViewControllerContextTransitioning) {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                let greenVC = transitionContext.viewController(forKey: .from) as! ViewControllerGreen
                greenVC.greenView.alpha = 0
            }
            animator!.addCompletion { [weak transitionContext] position in
                let completed = (position == .end)
                transitionContext?.completeTransition(completed)
            }
            animator!.startAnimation()
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
        self.transitionContext = transitionContext
        createAnimationIfItDoesNotExistYet(transitionContext)
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        NSLog("\(Self.description()) \(#function)")
        self.transitionContext = transitionContext
        createAnimationIfItDoesNotExistYet(transitionContext)
        return animator!
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
    }
    
    var wantsInteractiveStart: Bool {
        NSLog("\(Self.description()) \(#function) - returning \(false)")
        return false
    }
}
