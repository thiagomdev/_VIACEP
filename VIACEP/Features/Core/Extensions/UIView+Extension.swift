import UIKit

extension UIView {
    func add(subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}

extension UIStackView {
    func addStacks(_ view: UIView...) {
        view.forEach { newViews in
            addArrangedSubview(newViews)
        }
    }
}
