//
//  UITextField+Extension.swift
//  SaudiCalendar
//
//  Created by Anup Kumar on 4/12/19.
//  Copyright © 2019 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
//    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//    
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
}

class MATextField1: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
extension UIFont {
    var bold: UIFont { return withWeight(.bold) }
    var semibold: UIFont { return withWeight(.semibold) }
    var regular: UIFont { return withWeight(.regular) }
    
    private func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = weight
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
