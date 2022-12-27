import UIKit

enum Constants {
    enum Keys {
        static var isFirstRun = "isFirstRun"
    }
    enum Font {
        static var textHeader = UIFont(name: "Graphik", size: 30)
        static var textMain = UIFont(name: "Graphik", size: 15)
        static var textSmall = UIFont(name: "Graphik", size: 10)
        static var textExtraSmall = UIFont(name: "Graphik", size: 5)
    }
    
    enum Colors {
        static let black = UIColor { traitCollection in
            
            switch traitCollection.userInterfaceStyle {
            case .dark:
              return UIColor(white: 0.1, alpha: 1.0)
            default:
              return UIColor(white: 0.9, alpha: 1.0)
            }
        }
        static let white = UIColor { traitCollection in
            
            switch traitCollection.userInterfaceStyle {
            case .dark:
              return UIColor(white: 0.9, alpha: 1.0)
            default:
              return UIColor(white: 0.1, alpha: 1.0)
            }
        }
        static let superBlack = UIColor { traitCollection in
            
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(white: 0.0, alpha: 1.0)
            default:
                return UIColor(white: 1.0, alpha: 1.0)
            }
        }
        static let superWhite = UIColor { traitCollection in
            
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(white: 1.0, alpha: 1.0)
            default:
              return UIColor(white: 0.0, alpha: 1.0)
            }
        }
        static let gray = UIColor.systemGray2
    }
    
    enum Sizes {
        static let screenHeight = UIScreen.main.bounds.height
        static let screenWidth = UIScreen.main.bounds.width
        static let inset: CGFloat = 16
        static let cornerRadius: CGFloat = 10
        static let alpha: CGFloat = 0.9
    }
    
    enum Localization {
        static let notes = Bundle.main.localizedString(forKey: "Notes", value: "", table: "Localizable")
    }
}


