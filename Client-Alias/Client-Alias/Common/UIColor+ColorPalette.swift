import UIKit

extension UIColor {
    
  struct ColorPalette {
      
      static var acсentColor: UIColor {
          UIColor(red: 58 / 255, green: 81 / 255, blue: 151 / 255, alpha: 1)
      }
      
      static var secondSecondBackgroundColor: UIColor {
          UIColor { traits -> UIColor in
              traits.userInterfaceStyle == .dark ? UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1) : .secondarySystemGroupedBackground
                  }
      }
      
  }

}
