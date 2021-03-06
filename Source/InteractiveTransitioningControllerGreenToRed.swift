
import UIKit

class InteractiveTransitioningControllerGreenToRed: NSObject, UIGestureRecognizerDelegate, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning
{
    private var transitionContext: UIViewControllerContextTransitioning?
    private var animator: UIViewPropertyAnimator?
    weak var panGestureRecognizer: UIPanGestureRecognizer?

    init(_ vc: ViewControllerGreen) {
        panGestureRecognizer = vc.panGestureRecognizer
        super.init()
        panGestureRecognizer?.addTarget(self, action: #selector(handleGesture(_:)))
    }
    
    deinit {
        NSLog("\(Self.description()) \(#function)")
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        NSLog("\(#function) \(gestureRecognizer.state)")
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            NSLog("gestureRecognizer began")
            initiallyInteractive = true
        case .changed:
            animator!.pauseAnimation()
            NSLog("gestureRecognizer changed \(progress)")
            transitionContext!.pauseInteractiveTransition()
            animator!.fractionComplete = progress
            transitionContext!.updateInteractiveTransition(progress)
        case .cancelled:
            NSLog("gestureRecognizer cancelled")
            fatalError("This is never called?")
        case .ended:
            if transitionContext!.isInteractive {
                let v = gestureRecognizer.velocity(in: gestureRecognizer.view)
                if v.y < 0 {
                    animator!.isReversed = true
                    transitionContext!.cancelInteractiveTransition()
                } else {
                    transitionContext!.finishInteractiveTransition()
                }
            }
            animator!.continueAnimation(withTimingParameters: nil, durationFactor: 0)
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
        // this can be called multiple times for the same operation
        if let a = animator {
            return a
        }
        NSLog(" creating animator")
        let greenVC = transitionContext.viewController(forKey: .from) as! ViewControllerGreen
        
        let redVC: ViewControllerRed
        if let redNC = transitionContext.viewController(forKey: .to) as? UINavigationController {
            redVC = redNC.viewControllers.compactMap { $0 as? ViewControllerRed }.first!
        } else {
            redVC = transitionContext.viewController(forKey: .to) as! ViewControllerRed
        }
        
        let v = greenVC.greenView
        transitionContext.containerView.addSubview(v)
        v.constraints.forEach { $0.isActive = false }
        v.translatesAutoresizingMaskIntoConstraints = true
        let duration = transitionDuration(using: transitionContext)
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            v.frame = redVC.redView.frame
            v.backgroundColor = redVC.redView.backgroundColor
        }
        animator!.addCompletion { position in
            NSLog("animation completed at \(position)")
            self.initiallyInteractive = false
            if position == .start {
                NSLog("  cancelling")
                transitionContext.completeTransition(false)
            } else {
                NSLog("  finishing")
                transitionContext.completeTransition(true)
                v.removeFromSuperview()
                transitionContext.containerView.addSubview(redVC.view)
            }
        }
        animator!.startAnimation()
        return animator!
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function) interactive \(transitionContext.isInteractive)")
        if !transitionContext.isInteractive {
            let a = interruptibleAnimator(using: transitionContext)
            a.continueAnimation?(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        NSLog("\(Self.description()) \(#function)")
        // I do not understand why this would be necessary, but it is:
        if let redNC = transitionContext!.viewController(forKey: .to) as? UINavigationController {
            redNC.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var initiallyInteractive = false

    var wantsInteractiveStart: Bool {
        initiallyInteractive
    }
}
