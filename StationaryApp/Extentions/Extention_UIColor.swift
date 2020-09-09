//
//  Extention_UIColor.swift
//  SaudiCalendar
//
//  Created by TechGropse on 9/25/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //Updated From new design
    open class var appOrange: UIColor { get {
        return UIColor(red: (254/255.0), green:  (80/255.0), blue:  (0/255.0), alpha: 1)
        }
    }
    open class var darkFont: UIColor { get {
        return UIColor(red: (11/255.0), green:  (31/255.0), blue:  (60/255.0), alpha: 1)
        }
    }
    open class var lightFont: UIColor { get {
        return UIColor(red: (140/255.0), green:  (148/255.0), blue:  (159/255.0), alpha: 1)
        }
    }
    open class var lightShadowGray: UIColor { get {
        return UIColor(red: 234/255.0, green: 236/255.0, blue: 241/255.0, alpha: 1.0)
        }
    }
    open class var lightBackgroundGray: UIColor { get {
        return UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        }
    }
    open class var deletRed: UIColor { get {
        return UIColor(red: 255/255.0, green: 0/255.0, blue: 78/255.0, alpha: 1.0)
        }
    }
    
    open class var paidGreen: UIColor { get {
        return UIColor(red: 15/255.0, green: 202/255.0, blue: 156/255.0, alpha: 1.0)
        }
    }
    open class var darkBlue: UIColor { get {
        return UIColor(red: 10/255.0, green: 20/255.0, blue: 94/255.0, alpha: 1.0)
        }
    }
    open class var waitingYellow: UIColor { get {
        return UIColor(red: 221/255.0, green: 189/255.0, blue: 14/255.0, alpha: 1.0)
        }
    }
    public convenience init?(hexString: String) {
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            let scanner = Scanner(string: hexColor)
            scanner.scanLocation = 0
            
            var rgbValue: UInt64 = 0
            
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff, alpha: 1
            )
            return
        }
        
        return nil
    }
}
