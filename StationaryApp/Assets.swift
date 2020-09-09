//
//  Assets.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class Assets: NSObject {

}

class ProjectColor: NSObject {
    
    static let defaultBlue = UIColor(red: 32/255, green: 108/255, blue: 181/255, alpha: 1.0)
    static let defaultYellow = UIColor(red: 245/255, green: 234/255, blue: 26/255, alpha: 1.0)
    static let fadeBlueColor = UIColor(red: 169/255, green: 193/255, blue: 222/255, alpha: 1.0) //a9c1de
    static let fadeBlackColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1.0) //cccccc
    static let borderGrayColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0) //c4c4c4
    
}

class ProjectImages: NSObject {
    
    //menu icons
    static let my_address = UIImage(named: "my_address")!
    static let orders = UIImage(named: "orders")!
    static let my_wishlist = UIImage(named: "my_wishlist")!
    static let brands = UIImage(named: "brands")!
    static let deals = UIImage(named: "deals")!
    static let promocodes = UIImage(named: "promocodes")!
    static let returnPolicy = UIImage(named: "return")!
    static let notification = UIImage(named: "notification")!
    
    static let demoImg1 = UIImage(named: "profile001")!
    static let demoImg2 = UIImage(named: "profile002")!
    static let demoImg3 = UIImage(named: "profile003")!
    
    static let demoProjectImg1 = UIImage(named: "p1")!
    static let demoProjectImg2 = UIImage(named: "p2")!
    static let demoProjectImg3 = UIImage(named: "p3")!
    static let demoProjectImg4 = UIImage(named: "p4")!
    
    static let extraDemo1 = UIImage(named: "slide_banner_01")!
    static let extraDemo2 = UIImage(named: "slide_banner_02")!
    
    static let bannerDemo_01 = UIImage(named: "banner_01")
    static let bannerDemo_02 = UIImage(named: "banner_02")
    static let bannerDemo_03 = UIImage(named: "banner_03")
    static let bannerDemo_04 = UIImage(named: "banner_04")
    
    static let unfil_heart = UIImage(named: "unfil_heart")!
    static let fill_heart = UIImage(named: "fill_heart")!
    static let tick_fill = UIImage(named: "tick_fill")!
    static let tick_unfill = UIImage(named: "tick_unfill")!
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


// letter spacing
extension UIButton {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedTitle(for: .normal) {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                setTitle(.none, for: .normal)
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))

            setAttributedTitle(attributedString, for: .normal)
        }

        get {
            if let currentLetterSpace = attributedTitle(for: .normal)?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}
