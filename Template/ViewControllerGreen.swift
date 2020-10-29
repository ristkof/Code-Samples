//
//  ViewControllerGreen.swift
//  Template
//
//  Created by Kristof Van Landschoot on 29/10/2020.
//  Copyright © 2020 Ristkof. All rights reserved.
//

import UIKit

class ViewControllerGreen: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .yellow
        
        let v = ViewUtils.prepare(UIView()) {
            $0.backgroundColor = .green
        }
        
        view.addSubview(v)
        
        🚧.activate([
            v.topAnchor.constraint(equalTo: view.topAnchor),
            v.leftAnchor.constraint(equalTo: view.leftAnchor),
            v.rightAnchor.constraint(equalTo: view.rightAnchor),
            v.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}
