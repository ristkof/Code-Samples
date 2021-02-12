
import UIKit
import AVKit

class ViewControllerGreen: UIViewController, UIGestureRecognizerDelegate {
    lazy var panGestureRecognizer = UIPanGestureRecognizer()
    
    lazy var greenView = ViewUtils.prepare(UIView()) {
        $0.backgroundColor = .green
        $0.addGestureRecognizer(self.panGestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    
    deinit {
        NSLog("\(Self.description()) \(#function)")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
        
        view.addSubview(greenView)
        
        let b = ViewUtils.prepare(UIButton()) {
            $0.setTitle("Dismiss", for: .normal)
            $0.setTitleColor(.darkText, for: .normal)
        }
        
        view.addSubview(b)
        
        🚧.activate([
            greenView.topAnchor.constraint(equalTo: view.topAnchor),
            greenView.leftAnchor.constraint(equalTo: view.leftAnchor),
            greenView.rightAnchor.constraint(equalTo: view.rightAnchor),
            greenView.heightAnchor.constraint(equalToConstant: 200),
            
            b.topAnchor.constraint(equalTo: greenView.bottomAnchor),
            b.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        b.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
        panGestureRecognizer.addTarget(self, action: #selector(actionDismiss))
    }
    
    @objc func actionDismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
        
    override var prefersStatusBarHidden: Bool { true }
//    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}
