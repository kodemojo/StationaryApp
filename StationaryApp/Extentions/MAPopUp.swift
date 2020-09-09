//
//  MAPopUp.swift
//  MAPopUp
//
//  Created by Mohd Arsad on 31/03/19.
//  Copyright © 2019 Mohd Arsad. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showMAAlert(message:String, type: PopUp.Status) {
        PopUp.showMAStatusAlert(view: self.view, status: type, message: message)
    }
}
class PopUp: NSObject {
    
    enum Status {
        case success
        case error
        case warning
    }
    class func showAlert(message:String, type: PopUp.Status) {
        let view = Constant.appDelegate.window?.rootViewController
        self.showMAStatusAlert(view: view?.view ?? UIView(), status: type, message: message)
    }
    class func showMAStatusAlert(view: UIView,status: Status,message: String) {
        
        let xpos: CGFloat = 20
        let ypos: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width - (xpos * 2)
        let height: CGFloat = 60
        
        let viewFrame = CGRect(x: xpos, y: ypos, width: width, height: height)
        
        let popUpView = MAStatusPopUp(frame: viewFrame)
        popUpView.setupView(image: nil, message: message)
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(popUpView)
        
        popUpView.addConstraint(newView: popUpView)
        currentWindow?.bringSubviewToFront(popUpView)
        
    }
    
    //Just for helping
    class func showActivity() {
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainFrame = UIScreen.main.bounds
        
        let backgroundview = UIView.init(frame: CGRect.init(x: 0, y: 0, width:  mainFrame.size.width, height:  mainFrame.size.height))
        backgroundview.tag=1024;
        backgroundview.backgroundColor = UIColor.init(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.4)
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.center = backgroundview.center
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.color = UIColor.appOrange
        actInd.startAnimating()
        backgroundview.addSubview(actInd)
        currentWindow?.addSubview(backgroundview)
    }
    class func hideActivity() {
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.viewWithTag(1024)?.removeFromSuperview()
    }
}

class MAStatusPopUp: UIView {
    
    var timer: Timer?
    var timeCount: Int = 1
    var statusIV: UIImageView?
    var msgLbl: UILabel?
    var isImageAvailable: Bool = false
    private let animationTotalTime: Int = 3
    private let animationTime: TimeInterval = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupTimerForHideView), userInfo: nil, repeats: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func setupTimerForHideView() {
        if timeCount == animationTotalTime {
            timer?.invalidate()
            animateToHide()
        }
        timeCount += 1
    }
}
// MARK: - MAStatusPopUp Animation
extension MAStatusPopUp {
    private func animateToHide() {
        self.alpha = 0.0
        self.removeFromSuperview()
//        UIView.animate(withDuration: animationTime, animations: {
//            var frame = self.frame
//            frame.size.height = 0
//            self.frame = frame
//            self.msgLbl?.alpha = 0.0
//        }, completion: { isTrue in
//            self.alpha = 0.0
//            self.removeFromSuperview()
//        })
    }
    private func animateToShow() {
        self.alpha = 0.0
        UIView.animate(withDuration: animationTime, animations: {
            self.alpha = 1.0
            
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            
            var frame = self.frame
            frame.origin.y = topPadding!
            self.frame = frame
        })
    }
}
// MARK: - All Setup frames
extension MAStatusPopUp {
    
    func setupView(image: UIImage?,message: String?) {
        
        self.setupDropShadow()
        
        if let _ = image {
            isImageAvailable = true
        }
        self.setupStatusImageView(image: image)
        self.setupMessageLabel(text: message)
        animateToShow()
    }
    private func setupDropShadow() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10.0
    }
    private func setupStatusImageView(image: UIImage?) {
        let imageSquareSize: CGFloat = 15.0
        let frame = CGRect(x: 0, y: 0, width: imageSquareSize, height: imageSquareSize)
        self.statusIV = UIImageView(frame: frame)
        self.statusIV?.layer.cornerRadius = imageSquareSize / 2
        self.statusIV?.layer.backgroundColor = UIColor.clear.cgColor
        self.statusIV?.contentMode = .scaleAspectFit
        self.statusIV?.clipsToBounds = true
        if let img = image {
            self.statusIV?.image = img
        }
        self.addSubview(self.statusIV!)
        self.addImageConstraint(newView: self.statusIV!)
    }
    private func setupMessageLabel(text: String?) {
        let xpos: CGFloat = 5
        let ypos: CGFloat = 5
        let width: CGFloat = self.bounds.width - (2*xpos)
        let height: CGFloat = self.bounds.height - (2*ypos)
        
        let frame = CGRect(x: xpos, y: ypos, width: width, height: height)
        self.msgLbl = UILabel(frame: frame)
        self.msgLbl?.textColor = UIColor.black
        self.msgLbl?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        self.msgLbl?.numberOfLines = 0
        if let text = text {
            self.msgLbl?.text = text
        }
        self.addSubview(self.msgLbl!)
        self.addLabelConstraint(newView: self.msgLbl!)
    }
    
    func addConstraint(newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraints = NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: newView.superview, attribute: .leading, multiplier: 1.0, constant: 20)
        
        let trailingConstraints = NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: newView.superview, attribute: .trailing, multiplier: 1.0, constant: -20)
        
        let topConstraints = NSLayoutConstraint(item: newView, attribute: .topMargin, relatedBy: .equal, toItem: newView.superview, attribute: .topMargin, multiplier: 1.0, constant: 20)
        
        let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0.25, constant: 50)
        newView.superview!.addConstraints([leadingConstraints, trailingConstraints, topConstraints, heightConstraint])
    }
    private func addLabelConstraint(newView: UILabel) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraints = NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: newView.superview, attribute: .leading, multiplier: 1.0, constant: 20)
        
        let trailingConstraints = NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: self.statusIV!, attribute: .trailing, multiplier: 1.0, constant: -10)
        
        let bottomConstraints = NSLayoutConstraint(item: newView, attribute: .bottomMargin, relatedBy: .equal, toItem: newView.superview, attribute: .bottomMargin, multiplier: 1.0, constant: -20)
        
        let topConstraints = NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: newView.superview, attribute: .top, multiplier: 1.0, constant: 20)

        newView.superview!.addConstraints([leadingConstraints, trailingConstraints, bottomConstraints, topConstraints])
    }
    private func addImageConstraint(newView: UIImageView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraints = NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: newView.superview, attribute: .trailing, multiplier: 1.0, constant: -10)
        
        let verticalCenterConstraints = NSLayoutConstraint(item: newView, attribute: .centerY, relatedBy: .equal, toItem: newView.superview, attribute: .centerY, multiplier: 1.0, constant: 0)
        newView.superview!.addConstraints([trailingConstraints, verticalCenterConstraints])
    }
}


//MARK: - =========================================================================


class S13221earchView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.refreshDetails()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refreshDetails() {
        self.backgroundColor = .red
    }
}
