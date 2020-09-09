//
//  Extention_ViewController.swift
//  SaudiCalendar
//
//  Created by TechGropse on 10/16/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import UIKit
import Alamofire
import SystemConfiguration

enum dateComparedBy {
    case lessThan
    case greaterThan
    case equal
}

extension UIViewController {
    
    public var widthRatio : CGFloat {
        get {
            return UIScreen.main.bounds.width / 375.0
        }
    }
    
    public var isLogged : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constant.UserDefaultKeys.kIsRegistered)
        }
    }
    
    func getAttText(bySelectedText: String,string: String, fontName: UIFont) -> NSAttributedString {
        let myString : NSString = string as NSString
        let changeText = bySelectedText
        
        let range = (myString).range(of: changeText)
        let attribute = NSMutableAttributedString(string: myString as String)
        let fontAttribute = [ NSAttributedString.Key.font: fontName]
        attribute.addAttributes(fontAttribute, range: range)
        return attribute
    }
    
    func checkInternet() -> Bool {
        if !(self.hasInternetConnectivity()) {
            SupportMethod.showAlertMessage(messageStr: Alert.NoNetwork)
            return false
        }
        return true
    }
    
    func hasInternetConnectivity() -> Bool {
        
      var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)
      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
          SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
      }
      var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
      if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
      }
      /* Only Working for WIFI
       let isReachable = flags == .reachable
       let needsConnection = flags == .connectionRequired
       return isReachable && !needsConnection
       */
      // Working for Cellular and WIFI
      let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
      let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
      let ret = (isReachable && !needsConnection)
      return ret
    }
    
}
extension UIViewController {
    func showImageSelectionAlert(picker : UIImagePickerController){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("Camera")
            self.getImageByCamera(picker: picker)
        }
        let galleryAction = UIAlertAction(title: "Album", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("Album")
            self.getImageByPhotoStorage(picker: picker)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("No")
        }
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - ALERT Controller and ImagePickerController Delegate
    func getImageByCamera(picker : UIImagePickerController){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            picker.allowsEditing = false
            
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
            present(picker,animated: true,completion: nil)
        }
        else{
            SupportMethod.showAlertMessage(messageStr: "Device camera is not available")
        }
    }
    func getImageByPhotoStorage(picker : UIImagePickerController){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        present(picker, animated: true, completion: nil)
    }
    
    func getVideoByVideoStorage(picker : UIImagePickerController){
        picker.allowsEditing = false
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        present(picker, animated: true, completion: nil)
    }
}
extension UIViewController {
    
    func validateDateAccordingly (pickedDate : Date, comparedDate: Date, caparedByType : dateComparedBy ) -> Bool{
        switch  caparedByType {
        case .equal:
            return pickedDate.compare(comparedDate) == .orderedSame
        case .greaterThan :
            return pickedDate.compare(comparedDate) == .orderedDescending
        case .lessThan :
            return pickedDate.compare(comparedDate) == .orderedAscending
        }
    }
    
    func getDateFromString (dateStr : String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = formatter.date(from: dateStr)
        return convertedDate ?? Date()
    }
    func convertHexStringToColor(stringColor: String) -> UIColor {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: stringColor)
        scanner.scanHexInt32(&hexInt)
        let color = UIColor(
            red: CGFloat((hexInt & 0xFF0000) >> 16)/255,
            green: CGFloat((hexInt & 0xFF00) >> 8)/255,
            blue: CGFloat((hexInt & 0xFF))/255,
            alpha: 1)
        
        return color
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    func isValidAlphaNumeric(_ testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z]"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    func isValidAlphaNumericWithEmail(_ testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z@._-]"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    func isValidPanCard(_ testStr:String) -> Bool {
        
        let panRegEx = "[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}"
        let panTest = NSPredicate(format:"SELF MATCHES %@", panRegEx)
        let result = panTest.evaluate(with: testStr)
        return result
    }
    func isValidIFSCCode(_ testStr:String) -> Bool {
        
        let panRegEx = "^[A-Za-z]{4}[a-zA-Z0-9]{7}$"
        let panTest = NSPredicate(format:"SELF MATCHES %@", panRegEx)
        let result = panTest.evaluate(with: testStr)
        return result
    }
    func isValidAlphabet(_ testStr:String) -> Bool {
        
        let emailRegEx = "[A-Za-z ]"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    func isValidPassword(_ testStr:String) -> Bool {
        
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: testStr)
        return result
        
    }
    func isValidUrl(urlString: String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    func getHeaderAttributeString() -> NSAttributedString {
        let attribute = [NSAttributedString.Key.font: UIFont(name: "ProximaNovaA-Bold", size: 17)!]
        let textStr = NSMutableAttributedString.init(string: "MINISTRY IN THE ")
        textStr.addAttributes(attribute,
                                range: NSMakeRange(0, 1))
        
        let textStr2 = NSMutableAttributedString.init(string: "MARKETPLACE")
        textStr2.addAttributes(attribute,
        range: NSMakeRange(0, 1))
        
        textStr.append(textStr2)
        
        return textStr
    }
    
    func setRate(count: Int, rate1IV: UIImageView, rate2IV: UIImageView, rate3IV: UIImageView, rate4IV: UIImageView, rate5IV: UIImageView) {
        switch count {
        case 1:
            rate1IV.image = UIImage(named: "star_active")
            rate2IV.image = UIImage(named: "star_normal")
            rate3IV.image = UIImage(named: "star_normal")
            rate4IV.image = UIImage(named: "star_normal")
            rate5IV.image = UIImage(named: "star_normal")
            break
        case 2:
            rate1IV.image = UIImage(named: "star_active")
            rate2IV.image = UIImage(named: "star_active")
            rate3IV.image = UIImage(named: "star_normal")
            rate4IV.image = UIImage(named: "star_normal")
            rate5IV.image = UIImage(named: "star_normal")
            break
        case 3:
            rate1IV.image = UIImage(named: "star_active")
            rate2IV.image = UIImage(named: "star_active")
            rate3IV.image = UIImage(named: "star_active")
            rate4IV.image = UIImage(named: "star_normal")
            rate5IV.image = UIImage(named: "star_normal")
            break
        case 4:
            rate1IV.image = UIImage(named: "star_active")
            rate2IV.image = UIImage(named: "star_active")
            rate3IV.image = UIImage(named: "star_active")
            rate4IV.image = UIImage(named: "star_active")
            rate5IV.image = UIImage(named: "star_normal")
            break
        case 5:
            rate1IV.image = UIImage(named: "star_active")
            rate2IV.image = UIImage(named: "star_active")
            rate3IV.image = UIImage(named: "star_active")
            rate4IV.image = UIImage(named: "star_active")
            rate5IV.image = UIImage(named: "star_active")
            break
        default:
            rate1IV.image = UIImage(named: "star_normal")
            rate2IV.image = UIImage(named: "star_normal")
            rate3IV.image = UIImage(named: "star_normal")
            rate4IV.image = UIImage(named: "star_normal")
            rate5IV.image = UIImage(named: "star_normal")
        }
    }
}

extension UIViewController {
    func showActivityIndicator(uiView: UIView) {
        
        let backgroundview = UIView.init(frame: CGRect.init(x: 0, y: 0, width:  view.frame.size.width, height:  view.frame.size.height))
        backgroundview.tag=1024;
        backgroundview.backgroundColor = UIColor.init(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.4)
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.center = uiView.center
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.color = UIColor.appOrange
        actInd.startAnimating()
        backgroundview.addSubview(actInd)
        view.addSubview(backgroundview)
    }
    func hideActivityIndicator(uiView: UIView) {
        for subview in self.view.subviews {
            if subview.tag == 1024 {
                subview.removeFromSuperview()
            }
        }
        view.viewWithTag(1024)?.removeFromSuperview()
    }
}


