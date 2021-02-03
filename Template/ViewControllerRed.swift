
import UIKit

class ViewControllerRed: UIViewController {
    
    let redView = ViewUtils.prepare(UIView()) {
        $0.backgroundColor = .red
    }

    override func viewDidLoad() {
        view.backgroundColor = .yellow
        
        view.addSubview(redView)
        
        let b = ViewUtils.prepare(UIButton()) {
            $0.setTitle("Animate!", for: .normal)
            $0.setTitleColor(.darkText, for: .normal)
            $0.addTarget(self, action: #selector(self.animateToGreen), for: .touchUpInside)
        }
        
        view.addSubview(b)
        
        🚧.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            redView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            redView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            redView.heightAnchor.constraint(equalTo: redView.widthAnchor),
            
            b.topAnchor.constraint(equalTo: redView.bottomAnchor),
            b.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        
        super.viewDidLoad()
    }
    
    @objc func animateToGreen() {
        let greenvc = ViewControllerGreen()
        greenvc.transitioningDelegate = self
        greenvc.modalPresentationStyle = .custom
        greenvc.modalPresentationCapturesStatusBarAppearance = true
        present(greenvc, animated: true, completion: nil)
    }
}

extension ViewControllerRed: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AnimationController(redView)
    }
}
