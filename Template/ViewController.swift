
import UIKit

class ViewControllerRed: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
        
        let v = ViewUtils.prepare(UIView()) {
            $0.backgroundColor = .red
        }
        
        view.addSubview(v)
        
        let b = ViewUtils.prepare(UIButton()) {
            $0.setTitle("Animate!", for: .normal)
            $0.setTitleColor(.darkText, for: .normal)
        }
        
        view.addSubview(b)
        
        🚧.activate([
            v.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            v.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            v.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            v.heightAnchor.constraint(equalTo: v.widthAnchor),
            
            b.topAnchor.constraint(equalTo: v.bottomAnchor),
            b.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        
        super.viewDidLoad()
    }
}

