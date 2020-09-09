//
//  UIlabel_Extention.swift
//  SaudiCalendar
//
//  Created by TechGropse on 10/26/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(labelSize.width)
    }
}
extension UILabel {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }

    func underline(newText: String) {
        if let textString = self.text {
            let myString : NSString = textString as NSString
            let changeText = newText
            
            let textColor: UIColor = UIColor.black
            let underLineColor: UIColor = UIColor.black
            let underLineStyle = NSUnderlineStyle.single.rawValue
            
            let range = (myString).range(of: changeText)
            let attribute = NSMutableAttributedString(string: myString as String)
            let labelAtributes:[NSAttributedString.Key : Any]  = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.underlineStyle: underLineStyle,
                NSAttributedString.Key.underlineColor: underLineColor
            ]
            
            attribute.addAttributes(labelAtributes, range: range)
            self.attributedText = attribute
            
        }
    }
}

class ProgressLabel: UIView {

    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        // Set up environment.
        let size = bounds.size
        let backgroundColor = UIColor(red: 108/255, green: 200/255, blue: 226/255, alpha: 1)
        let foregroundColor = UIColor.white
        let font = UIFont.boldSystemFont(ofSize: 15)

        // Prepare progress as a string.
        let progress = NSString(format: "%d%%", Int(round(self.progress * 100))) // this cannot be a String because there are many subsequent calls to NSString-only methods such as `size` and `draw`
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textSize = progress.size(withAttributes: attributes)
        let progressX = ceil(self.progress * size.width)
        let textPoint = CGPoint(x: ceil((size.width - textSize.width) / 2), y: ceil((size.height - textSize.height) / 2))

        // Draw background + foreground text
        backgroundColor.setFill()
        context?.fill(bounds)
        attributes[.foregroundColor] = foregroundColor
        progress.draw(at: textPoint, withAttributes: attributes)

        // Clip the drawing that follows to the remaining progress's frame
        context?.saveGState()
        let remainingProgressRect = CGRect(x: progressX, y: 0, width: size.width - progressX, height: size.height)
        context?.addRect(remainingProgressRect)
        context?.clip()

        // Draw again with inverted colors
        foregroundColor.setFill()
        context?.fill(bounds)
        attributes[.foregroundColor] = backgroundColor
        progress.draw(at: textPoint, withAttributes: attributes)

        context?.restoreGState()
    }
}

class MyProgressLabel1: UIView {

    var progressBarColor = UIColor(red:108.0/255.0, green:200.0/255.0, blue:226.0/255.0, alpha:1.0)
    var textColor = UIColor.white
    var font = UIFont.boldSystemFont(ofSize: 42)


    var progress: Float = 0 {
        didSet {
            progress = Float.minimum(100.0, Float.maximum(progress, 0.0))
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        // Set up environment.
        let size = self.bounds.size

        // Prepare progress as a string.
        let progressMessage = NSString(format:"%d %%", Int(progress))
        var attributes: [NSAttributedString.Key:Any] = [ NSAttributedString.Key.font : font ]
        let textSize = progressMessage.size(withAttributes: attributes)
        let progressX = ceil(CGFloat(progress) / 100 * size.width)
        let textPoint = CGPoint(x: ceil((size.width - textSize.width) / 2.0), y: ceil((size.height - textSize.height) / 2.0))

        // Draw background + foreground text
        progressBarColor.setFill()
        context.fill(self.bounds)
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        progressMessage.draw(at: textPoint, withAttributes: attributes)

        // Clip the drawing that follows to the remaining progress' frame.
        context.saveGState()
        let remainingProgressRect = CGRect(x: progressX, y: 0.0, width: size.width - progressX, height: size.height)
        context.addRect(remainingProgressRect)
        context.clip()

        // Draw again with inverted colors.
        textColor.setFill()
        context.fill(self.bounds)
        attributes[NSAttributedString.Key.foregroundColor] = progressBarColor
        progressMessage.draw(at: textPoint, withAttributes: attributes)

        context.restoreGState()
    }
}

class MyProgressLabel: UIProgressView {

}
