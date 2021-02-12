
import UIKit

class ViewUtils {
    class func prepare<T>(_ v: T, finish: ((T) -> ())? = nil) -> T where T:UIView {
        v.translatesAutoresizingMaskIntoConstraints = false
        finish?(v)
        return v
    }
}
