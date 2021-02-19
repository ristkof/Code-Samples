
import UIKit

class InteractiveTransitioningControllerBlueToRed: NSObject, UIGestureRecognizerDelegate, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning
{
    private var transitionContext: UIViewControllerContextTransitioning?
    private var animator: UIViewPropertyAnimator?
    var panGestureRecognizer: UIPanGestureRecognizer?

    init(_ vc: ViewControllerBlue) {
        super.init()
        panGestureRecognizer = vc.scrollView.panGestureRecognizer
        panGestureRecognizer?.addTarget(self, action: #selector(handleGesture(_:)))
    }
    
    deinit {
        panGestureRecognizer?.removeTarget(self, action: nil)
        NSLog("\(Self.description()) \(#function)")
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        NSLog("\(#function) \(gestureRecognizer.state.description)")
        let blueVC = transitionContext!.viewController(forKey: .from) as! ViewControllerBlue

        let offset = gestureRecognizer.translation(in: blueVC.scrollView)
        NSLog("offset: \(offset)")
        var progress = offset.y / 200
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        NSLog("gestureRecognizer \(gestureRecognizer.state.description) offset \(blueVC.scrollView.contentOffset.y) progress \(progress)")
        switch gestureRecognizer.state {
        case .began:
            initiallyInteractive = true
        case .changed:
            animator!.pauseAnimation()
            NSLog("gestureRecognizer changed \(progress)")
            transitionContext!.pauseInteractiveTransition()
            animator!.fractionComplete = progress
            transitionContext!.updateInteractiveTransition(progress)
        case .ended:
            if transitionContext!.isInteractive {
                if progress > 0.3 {
                    transitionContext!.finishInteractiveTransition()
                } else {
                    animator!.isReversed = true
                    transitionContext!.cancelInteractiveTransition()
                }
                animator!.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default:
            break
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        NSLog("\(Self.description()) \(#function) \(transitionContext)")
        self.transitionContext = transitionContext
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
        self.transitionContext = transitionContext
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        NSLog("\(Self.description()) \(#function)")
        self.transitionContext = transitionContext
        if let a = animator { return a }
        let blueVC = transitionContext.viewController(forKey: .from) as! ViewControllerBlue
        
        let redVC: ViewControllerRed
        if let redNC = transitionContext.viewController(forKey: .to) as? UINavigationController {
            redVC = redNC.viewControllers.compactMap { $0 as? ViewControllerRed }.first!
        } else {
            redVC = transitionContext.viewController(forKey: .to) as! ViewControllerRed
        }
        
        let v = blueVC.blueView
        let b = blueVC.blueView.bounds
        let r = blueVC.blueView.convert(b, to: blueVC.view)
        let transitionBlueView = UIView(frame: r)
        transitionBlueView.backgroundColor = .systemBlue
        transitionContext.containerView.addSubview(transitionBlueView)
        v.isHidden = true
        let duration = transitionDuration(using: transitionContext)
        NSLog("creating animation")
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            transitionBlueView.frame = redVC.redView.frame
            transitionBlueView.backgroundColor = redVC.redView.backgroundColor
        }
        animator!.addCompletion { position in
            self.initiallyInteractive = false
            transitionBlueView.removeFromSuperview()
            NSLog("animation ended at \(position)")
            if position == .start {
                NSLog(" cancelling")
                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
                v.isHidden = false
            } else {
                NSLog(" finishing")
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
                v.removeFromSuperview()
                transitionContext.containerView.addSubview(redVC.view)
            }
        }
        animator!.pauseAnimation()
        return animator!
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
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
