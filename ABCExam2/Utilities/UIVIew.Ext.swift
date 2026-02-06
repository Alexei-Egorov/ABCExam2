import UIKit

// MARK: - disableAutoresizing

extension UIView {
    
    @discardableResult
    func disableAutoresizingMask() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
