//
//  ViewControllerGreen.swift
//  Template
//
//  Created by Kristof Van Landschoot on 29/10/2020.
//  Copyright © 2020 Ristkof. All rights reserved.
//

import UIKit

class ViewControllerGreen: UIViewController {    
    let greenView = ViewUtils.prepare(UIView()) {
        $0.backgroundColor = .green
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
        
        b.addTarget(self, action: #selector(doDismiss), for: .touchUpInside)
    }
    
    @objc func doDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool { true }
//    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}
