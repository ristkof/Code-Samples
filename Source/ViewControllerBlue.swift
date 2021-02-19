
import UIKit

class ViewControllerBlue: UIViewController {
    var scrollView: UIScrollView!
    let blueView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

    var isPopped = false
    private var scrollViewObservation: NSKeyValueObservation?

    deinit {
        NSLog("\(Self.description()) \(#function)")
        scrollViewObservation?.invalidate()
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = "\(Self.description())"

        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        scrollView.panGestureRecognizer.addTarget(self, action: #selector(grScrollAction(_:)))
        blueView.backgroundColor = .systemBlue
        scrollView.addSubview(blueView)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 2000)
    }
    
    @objc private func grScrollAction(_ pgr: UIPanGestureRecognizer) {
        // getting the cutoff here to be something else than 0 is complicated because in this simplified
        // scenario we're going to cancel the scroll when the pop has started
        // continuing a scroll when the pop has started and then cancelled is next level
//        NSLog("offset: \(scrollView.contentOffset) state: \(pgr.state.description)")
        if scrollView.contentOffset.y + scrollView.adjustedContentInset.top < 0 {
            if !isPopped {
                NSLog("popping")
                navigationController?.popViewController(animated: true)
                isPopped = true
            }
        }
        if pgr.state == .ended {
            isPopped = false
        }
    }
}
