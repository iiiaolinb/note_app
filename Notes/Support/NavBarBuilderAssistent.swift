import UIKit


    //the function helps to quickly create buttons
    //with preset settings for the navigation bar
func buildNavigationBarButton(imageName: String?, title: String?, color: UIColor, target: Any?, action: Selector) -> UIBarButtonItem {
    
    let button = UIButton(type: .custom)
    button.backgroundColor = color
    button.layer.cornerRadius = 7
    button.clipsToBounds = true
    button.addTarget(target, action: action, for: .touchUpInside)
    if let imageName = imageName { button.setImage(UIImage(named: imageName), for: .normal) }
    if let title = title { button.setTitle(title, for: .normal) }
    
    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 30),
        button.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    let barItem = UIBarButtonItem(customView: button)
    return barItem
}
