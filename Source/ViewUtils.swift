//
//  ViewUtils.swift
//  Template
//
//  Created by Kristof Van Landschoot on 29/10/2020.
//  Copyright © 2020 Ristkof. All rights reserved.
//

import UIKit

class ViewUtils {
    class func prepare<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UIView {
        v.translatesAutoresizingMaskIntoConstraints = false
        finish?(v)
        return v
    }
}
