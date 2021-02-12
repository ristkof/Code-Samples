
import UIKit

typealias 🚧 = NSLayoutConstraint

protocol TBLRConstraint {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: TBLRConstraint {
    
}

extension UILayoutGuide: TBLRConstraint {
    
}

extension NSLayoutConstraint {
    func priority(_ p:UILayoutPriority) -> NSLayoutConstraint {
        priority = p
        return self
    }
    
    func store(in: inout NSLayoutConstraint) -> NSLayoutConstraint {
        `in` = self
        return self
    }

    @discardableResult func store(in: inout Set<NSLayoutConstraint>) -> NSLayoutConstraint {
        `in`.insert(self)
        return self
    }
    
    @discardableResult func identifier(_ s: String) -> NSLayoutConstraint {
        identifier = s
        return self
    }
    
    @discardableResult static func pin<T: TBLRConstraint, U: TBLRConstraint>(_ v1: T, _ v2: U) -> [NSLayoutConstraint] {
        let rv = [
            v1.topAnchor.constraint(equalTo: v2.topAnchor),
            v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor),
            v1.leftAnchor.constraint(equalTo: v2.leftAnchor),
            v1.rightAnchor.constraint(equalTo: v2.rightAnchor),
        ]
        activate(rv)
        return rv
    }
}
