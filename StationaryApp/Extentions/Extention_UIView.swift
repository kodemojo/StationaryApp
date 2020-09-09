//
//  Extention_UIView.swift
//  SaudiCalendar
//
//  Created by TechGropse on 9/24/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension UIView {
    
    /// Set Greadient on any View From Start to end
    ///
    /// - Parameters:
    ///   - cornerRadius: set corner Radius for the View , give any value in float
    ///   - firstColor: give initial color or Start color
    ///   - secoundColor: give End  color or Start color
    public  func setGradient(cornerRadius : CGFloat, firstColor : UIColor, secoundColor : UIColor) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secoundColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = cornerRadius
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    public  func setBottomToTopGradient(cornerRadius : CGFloat, firstColor : UIColor, secoundColor : UIColor) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, firstColor.cgColor, secoundColor.cgColor]
        gradient.locations = [0.0, 0.4, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        gradient.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    public  func setFloatingGradient(cornerRadius : CGFloat, firstColor : UIColor, secoundColor : UIColor) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secoundColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.cornerRadius = cornerRadius
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public  func setClearGradient() {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
    }
    /// Set shadow over a view
    ///
    /// - Parameters:
    ///   - shadowColor: uicolor type
    ///   - opacity: float
    public func setShadow(shadowColor : UIColor , opacity :  CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
    }
    
//    func roundCorners(corners : [CGR], cornerRadius: Double) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = path.cgPath
//        self.layer.mask = maskLayer
//    }
    
    public func setCornerRadiusWithBorderColor (borderColor : UIColor, borderWidth : CGFloat, radius : CGFloat,backGroundColor : UIColor) {
        self.backgroundColor = backGroundColor
        self.layer.cornerRadius =  radius
        self.layer.borderWidth =  borderWidth
        self.layer.borderColor =  borderColor.cgColor
        self.clipsToBounds =  true
    }
    public func setBorder(color : UIColor,width : CGFloat,radius : CGFloat) {
        self.layer.cornerRadius =  radius
        self.layer.borderWidth =  width
        self.layer.borderColor =  color.cgColor
        self.clipsToBounds =  true
    }
    func setGradient(cornerRadius : CGFloat) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        let gradient: CAGradientLayer = CAGradientLayer()
     
        gradient.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = cornerRadius
        
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    func clearGradient(cornerRadius : CGFloat) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        let bottomColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
        let topColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
        gradient.colors = [bottomColor.cgColor, topColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = cornerRadius
        gradient.frame = self.bounds
        
        
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = path.cgPath
//        gradient.mask = maskLayer
//
//        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setSideDropShadow(isUp : Bool) {
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                    self.backgroundColor = UIColor.white
                }
            }
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = isUp ? 0.1 : 0.04
        self.layer.shadowOffset = CGSize(width: 0, height: isUp ? -5 : 5)
        self.layer.shadowRadius = 5.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = 0.0
    }
    func setDropShadow(cornerRadius : CGFloat) {
        self.backgroundColor = UIColor.white
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                    self.backgroundColor = UIColor.white
                }
            }
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = cornerRadius
    }
    func setLightDropShadow(cornerRadius : CGFloat) {
        self.backgroundColor = UIColor.white
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
                    self.backgroundColor = UIColor.white
                }
            }
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.20
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.cornerRadius = cornerRadius
    }
    
    func setLightDropShadow(color: UIColor, opacity: Float) {
//        self.backgroundColor = UIColor.white
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAGradientLayer) != nil) {
                    gradient.removeFromSuperlayer()
//                    self.backgroundColor = UIColor.white
                }
            }
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
    }
    
    func setCorner(corners : UIRectCorner, radius : CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
    }
    func setChatCorner(corners : UIRectCorner, radius : CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
        
        
//        let square = UIView()
//        square.center = view.center
//        square.bounds.size = CGSize(width: 100, height: 100)
        self.backgroundColor = .black
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        UIViewPropertyAnimator(duration: 3.0, curve: .easeIn) {
            self.layer.cornerRadius = 20
            }.startAnimation()
    }
    func setDottedtLine(color: UIColor = .lightGray) {
        
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAShapeLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        
        let lineDashPatterns: [[NSNumber]?]  = [[5,4]]
        for (index, lineDashPattern) in lineDashPatterns.enumerated() {
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 1.5
            shapeLayer.lineDashPattern = lineDashPattern
            
            let path = CGMutablePath()
            let y = CGFloat(index * 50)
            path.addLines(between: [CGPoint(x: 0, y: y),
                                    CGPoint(x: self.frame.size.width, y: y)])
            
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    }
    func setHorizontalDottedLine(color: UIColor = .lightGray) {
        //Clear Line
        if self.layer.sublayers != nil {
            for gradient in self.layer.sublayers! {
                if ((gradient as? CAShapeLayer) != nil) {
                    gradient.removeFromSuperlayer()
                }
            }
        }
        
        //Ad New Dotted Line
        let lineDashPatterns: [[NSNumber]?]  = [[5,4]]
        for (index, lineDashPattern) in lineDashPatterns.enumerated() {
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 3
            shapeLayer.lineDashPattern = lineDashPattern
            
            let path = CGMutablePath()
            let x = CGFloat(index * 50)
            path.addLines(between: [CGPoint(x: x, y: 0),
                                    CGPoint(x: x, y: self.frame.size.height)])
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    }
    func setCircleCorner() {
        self.layer.cornerRadius =  self.layer.frame.size.height/2
        self.clipsToBounds =  true
    }
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
public extension String {
    
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
    
    public var arabicDigits: String {
        var str = self
     /*   let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"] */
        let map = ["0" : "٠",
                   "1" : "١",
                   "2" : "٢",
                   "3" : "٣",
                   "4" : "٤",
                   "5" : "٥",
                   "6" : "٦",
                   "7" : "٧",
                   "8" : "٨",
                   "9" : "٩"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    var underLineAttributeString: NSAttributedString {
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.7),
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: self,
                                                        attributes: yourAttributes)
        return attributeString
    }
    
    var strikeThroughAttributeString: NSAttributedString {
        let yourAttributes: [NSAttributedString.Key: Any] = [ .strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: self,
                                                        attributes: yourAttributes)
        return attributeString
    }
    
    /// Thumbnail Image from URL
    ///
    /// - Parameters:
    ///   - url: video url to get thumbnail image
    ///   - completion: thumbnail image
    func thumbnailImageFromVideoUrl(completion: @escaping ((_ image: UIImage?)->Void)) {
        let URLString = self
        DispatchQueue.global().async {
            if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
                completion(cachedImage)
                return
            }
            if let url = URL(string: URLString) {
                let asset = AVAsset(url: url)
                let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                avAssetImageGenerator.appliesPreferredTrackTransform = true
                let thumnailTime = CMTimeMake(value: 2, timescale: 1)
                do {
                    let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                    let thumbImage = UIImage(cgImage: cgThumbImage)
                    imageCache.setObject(thumbImage, forKey: NSString(string: URLString))
                    completion(thumbImage)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}
extension UIButton {
    func getUnderlineAttributeString(_ color: UIColor? = (UIColor.black.withAlphaComponent(0.7))) -> NSAttributedString {
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: self.titleLabel!.font!,
            .foregroundColor: color ?? (UIColor.black.withAlphaComponent(0.7)),
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: self.currentTitle!,
                                                        attributes: yourAttributes)
        return attributeString
    }
}
extension UIView {
    class func loadFromNibNamed(nibNamed: String, frame : CGRect) -> UIView? {
        let tView = UINib(
            nibName: nibNamed,
            bundle: nil
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
        tView?.frame = frame
        return tView
    }
}
