
import UIKit

class AnimatedTransitioningControllerRedToGreen: NSObject & UIViewControllerAnimatedTransitioning {
    let redView: UIView
    
    init(_ rv: UIView) {
        redView = rv
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        // even though we present from ViewControllerRed, we still get the from as a UINavigationController
        assert(transitionContext.viewController(forKey: .from) is UINavigationController)
        
        let toVC = transitionContext.viewController(forKey: .to) as! ViewControllerGreen

        redView.isHidden = true
        let animatingSquareView = UIView(frame: redView.frame)
        animatingSquareView.backgroundColor = .red
        containerView.addSubview(animatingSquareView)
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
