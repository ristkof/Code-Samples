
import UIKit

extension UIGestureRecognizer.State {
    var description: String {
        switch self {
        case .began: return "began"
        case .cancelled: return "cancelled"
        case .changed: return "changed"
        case .ended: return "ended"
        case .possible: return "possible"
        case .failed: return "failed"
        @unknown default:
            fatalError("Unknown default")
        }
    }
}
