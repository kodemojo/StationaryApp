//
//  Extention_PageControl.swift
//  SaudiCalendar
//
//  Created by TechGropse on 9/24/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import UIKit
extension UIPageControl {
    func setDot () {
        self.currentPageIndicatorTintColor =  UIColor(patternImage: UIImage(named: "sliderActiveDot")!)
        self.pageIndicatorTintColor =  UIColor(patternImage: UIImage(named: "sliderUnActiveDot")!)
//        self.currentPageIndicatorTintColor = UIColor.bluishNew
//        self.pageIndicatorTintColor =  UIColor.lightGray
        self.numberOfPages =  3
    }
}

class MAPageControl: UIPageControl {
    
    //Override Methods
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
    //Helping Methods
    var activeDot: UIImage {
        return UIImage (named: "sliderActiveDot")! // Image you want to replace with dots
    }
    
    var unActiveDot: UIImage {
        return UIImage (named: "sliderUnActiveDot")!//Default Image
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            var imageView = self.imageView(forSubview: view)
            imageView?.contentMode = .scaleAspectFit
            if imageView == nil {
                imageView = UIImageView()
                imageView?.frame = getUpdatedFrame(rect: imageView!.frame, isActive: false)
//                imageView!.center = view.center
//                imageView?.contentMode = .center
                imageView?.layer.cornerRadius = 3.0
                view.addSubview(imageView!)
                view.clipsToBounds = false
            }
            if i == self.currentPage {
                imageView!.alpha = 1.0
                imageView?.backgroundColor = .clear//.white
                imageView?.image = activeDot
                imageView?.frame = getUpdatedFrame(rect: imageView!.frame, isActive: true)
            } else {
                imageView!.alpha = 0.5
                imageView?.backgroundColor = .clear//.lightGray
                imageView?.image = unActiveDot
                imageView?.frame = getUpdatedFrame(rect: imageView!.frame, isActive: false)
            }
            i += 1
        }
    }
    
    fileprivate func imageView(forSubview view: UIView) -> UIImageView? {
        var dot: UIImageView?
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
    private func getUpdatedFrame(rect: CGRect, isActive: Bool) -> CGRect {
        let normalWidth: CGFloat = 6.0
        var frame = rect
        frame.origin.y = 0.0 //(self.bounds.height - normalWidth) / 2
        frame.size.width = isActive ? 11.0 : normalWidth
        frame.size.height = normalWidth
        return frame
    }
}
