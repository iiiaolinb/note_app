import UIKit

    //the extension helps you quickly set
    //the desired settings for the button
extension UIButton {
    convenience init(title: String, target: Any, selector: Selector?) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        guard let selector = selector else { return }
        addTarget(target, action: selector, for: .touchUpInside)
    }
}
