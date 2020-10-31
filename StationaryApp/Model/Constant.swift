//
//  Constant.swift
//  MIM
//
//  Created by Mohd Arsad on 22/02/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

/// Main constant support data
struct Constant {
    
    static let imageCompressQuality: CGFloat = 0.3
    static let defaultCountryCode: String = "218"
    
    static let APP_NAME = "Stationary"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
    struct UserDefaultKeys {
        
        static let kIsRegistered        = "kIsRegistered"
        static let kIsGuestRegistered   = "kIsGuestRegistered"
        static let kIsTutorialRead      = "kIsTutorialRead"
        
        static let firstName            = "firstName"
        static let lastName             = "lastName"
        static let email                = "emailemail"
        static let websiteId            = "websiteId"
        static let cartId               = "cartId"
        static let guestCartId          = "guestCartId"
        static let cartCount            = "cartCount"
        
        
        //Single Data Keys
        static let kDeviceToken         = "deviceToken"
        static let kUserSecuirityToken  = "SecuirityToken"
        static let kAdminSecuirityToken = "kAdminSecuirityToken"
        
        static let kSelectedLanguage    = "kSelectedLanguage"
        
        static let kUserId              = "kUserId"
        static let kOTP                 = "kOTP"
        static let fullName             = "fullName"
        
        static let countryCode          = "countryCode"
        static let mobile               = "mobilemobile"
        static let profileImage         = "profileImage"
        static let city                 = "citycity"
        static let stateId              = "stateIdstateId"
        static let zipCode              = "zipCodezipCode"
        static let stateName            = "stateName"
        static let stateCode            = "stateCode"
        
        static let latitude             = "latitude"
        static let longitude            = "longitude"
        static let location             = "location"
        
        static let appleLanguages             = "AppleLanguages"
    }
}

/// All alert constant
struct Alert {
    static let NoNetwork = "No Internet Available!".localized
    static let doLoginMessage = "Please do login to check your profile!".localized
    
    static let emptyFirstName = "Please enter your first name".localized
    static let emptyLastName = "Please enter your last name".localized
    static let emptyEmail = "Please enter your email".localized
    static let wrongEmail = "Email is not correct!".localized
    static let emptyPassword = "Please enter your password".localized
    static let emptyOldPassword = "Please enter your old password".localized
    static let emptyNewPassword = "Please enter new password".localized
    static let wrongPasswordLength = "Password must be minimum 8 characters".localized
    static let wrongPassword = "Password should consist of lower case character, upper case character, digit and special symbol and mimimum 8 character.".localized
    static let emptyConfirmPassword = "Please enter confirm password".localized
    static let wrongConfirmPassword = "Confirm password does not macthed!".localized
    static let emptyFullName = "Please enter your name".localized
    static let emptyMobile = "Please enter your mobile number".localized
    static let wrongMobileLength = "Enter correct mobile number".localized
    
    static let emptyBuildingNo = "Please enter building number".localized
    static let emptyStreetNo = "Please enter street number".localized
    static let emptyCountryName = "Please select country".localized
    static let emptyZone = "Please enter zone name".localized
    static let emptyZipcode = "Please enter your zipcode".localized
    
}

class SupportMethod {
    
    static func updateRating(img1: UIImageView, img2: UIImageView, img3: UIImageView, img4: UIImageView, img5: UIImageView, rate: Int) {
        
        img1.image = UIImage(named: "star_rating_unfill")
        img2.image = UIImage(named: "star_rating_unfill")
        img3.image = UIImage(named: "star_rating_unfill")
        img4.image = UIImage(named: "star_rating_unfill")
        img5.image = UIImage(named: "star_rating_unfill")
        
        if rate == 1 {
            img1.image = UIImage(named: "star_rating")
        } else if rate == 2 {
            img1.image = UIImage(named: "star_rating")
            img2.image = UIImage(named: "star_rating")
        } else if rate == 3 {
            img1.image = UIImage(named: "star_rating")
            img2.image = UIImage(named: "star_rating")
            img3.image = UIImage(named: "star_rating")
        } else if rate == 4 {
            img1.image = UIImage(named: "star_rating")
            img2.image = UIImage(named: "star_rating")
            img3.image = UIImage(named: "star_rating")
            img4.image = UIImage(named: "star_rating")
        } else {
            img1.image = UIImage(named: "star_rating")
            img2.image = UIImage(named: "star_rating")
            img3.image = UIImage(named: "star_rating")
            img4.image = UIImage(named: "star_rating")
            img5.image = UIImage(named: "star_rating")
        }
    }
    
    static func updateRatingOnButton(img1: UIButton, img2: UIButton, img3: UIButton, img4: UIButton, img5: UIButton, rate: Int) {
        
        img1.setImage(UIImage(named: "star_rating_unfill"), for: .normal)
        img2.setImage(UIImage(named: "star_rating_unfill"), for: .normal)
        img3.setImage(UIImage(named: "star_rating_unfill"), for: .normal)
        img4.setImage(UIImage(named: "star_rating_unfill"), for: .normal)
        img5.setImage(UIImage(named: "star_rating_unfill"), for: .normal)
        
        if rate == 1 {
            img1.setImage(UIImage(named: "star_rating"), for: .normal)
        } else if rate == 2 {
            img1.setImage(UIImage(named: "star_rating"), for: .normal)
            img2.setImage(UIImage(named: "star_rating"), for: .normal)
        } else if rate == 3 {
            img1.setImage(UIImage(named: "star_rating"), for: .normal)
            img2.setImage(UIImage(named: "star_rating"), for: .normal)
            img3.setImage(UIImage(named: "star_rating"), for: .normal)
        } else if rate == 4 {
            img1.setImage(UIImage(named: "star_rating"), for: .normal)
            img2.setImage(UIImage(named: "star_rating"), for: .normal)
            img3.setImage(UIImage(named: "star_rating"), for: .normal)
            img4.setImage(UIImage(named: "star_rating"), for: .normal)
        } else {
            img1.setImage(UIImage(named: "star_rating"), for: .normal)
            img2.setImage(UIImage(named: "star_rating"), for: .normal)
            img3.setImage(UIImage(named: "star_rating"), for: .normal)
            img4.setImage(UIImage(named: "star_rating"), for: .normal)
            img5.setImage(UIImage(named: "star_rating"), for: .normal)
        }
    }
    
    static func getJsonString(object: Any) -> String? {
      guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
      }
      return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func getJsonString(array: [Any]) -> String? {
      guard let data = try? JSONSerialization.data(withJSONObject: array, options: []) else {
        return nil
      }
      return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func showAlertMessage(messageStr:String) {
        PopUp.showAlert(message: messageStr, type: .success)
    }
    
    static func cachedUserLoginData(data: Profile) {
        
        UserDefaults.standard.set("\(data.id ?? 0)", forKey: Constant.UserDefaultKeys.kUserId)
        UserDefaults.standard.set(data.firstname ?? "", forKey: Constant.UserDefaultKeys.firstName)
        UserDefaults.standard.set(data.lastname ?? "", forKey: Constant.UserDefaultKeys.lastName)
        UserDefaults.standard.set(data.email, forKey: Constant.UserDefaultKeys.email)
        UserDefaults.standard.set("\(data.website_id ?? 0)", forKey: Constant.UserDefaultKeys.websiteId)
        
//        UserDefaults.standard.set(data.image, forKey: Constant.UserDefaultKeys.profileImage)
//        UserDefaults.standard.set(data.country_code, forKey: Constant.UserDefaultKeys.countryCode)
//        UserDefaults.standard.set(data.mobile, forKey: Constant.UserDefaultKeys.mobile)
    
//        if let token = data.security_token {
//            UserDefaults.standard.set(token, forKey: Constant.UserDefaultKeys.kUserSecuirityToken)
//        }
    }
    
    static func cachedClearedData() {
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.kIsGuestRegistered)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.kIsRegistered)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.kUserId)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.fullName)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.email)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.profileImage)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.countryCode)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.mobile)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.kUserSecuirityToken)
        
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.firstName)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.lastName)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.websiteId)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.cartId)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.guestCartId)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.kDeviceToken)
        UserDefaults.standard.set(nil, forKey: Constant.UserDefaultKeys.kAdminSecuirityToken)
        UserDefaults.standard.set("0", forKey: Constant.UserDefaultKeys.cartCount)
    }
    
    static func changeDateTime(by dateTime: String, dateTimeFormat: String, convertedFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat  = dateTimeFormat
        if let date = formatter.date(from: dateTime) {
            formatter.dateFormat = convertedFormat
            let from = formatter.string(from: date)
            return from
        }
        return ""
    }
    
    static var isLogged : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constant.UserDefaultKeys.kIsRegistered)
        }
    }
}

internal let DEFAULT_MIME_TYPE = "application/octet-stream"
internal let mimeTypes = [
    "md": "text/markdown",
    "html": "text/html",
    "htm": "text/html",
    "shtml": "text/html",
    "css": "text/css",
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "js": "application/javascript",
    "atom": "application/atom+xml",
    "rss": "application/rss+xml",
    "mml": "text/mathml",
    "txt": "text/plain",
    "jad": "text/vnd.sun.j2me.app-descriptor",
    "wml": "text/vnd.wap.wml",
    "htc": "text/x-component",
    "png": "image/png",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "wbmp": "image/vnd.wap.wbmp",
    "ico": "image/x-icon",
    "jng": "image/x-jng",
    "bmp": "image/x-ms-bmp",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "webp": "image/webp",
    "woff": "application/font-woff",
    "jar": "application/java-archive",
    "war": "application/java-archive",
    "ear": "application/java-archive",
    "json": "application/json",
    "hqx": "application/mac-binhex40",
    "doc": "application/msword",
    "pdf": "application/pdf",
    "ps": "application/postscript",
    "eps": "application/postscript",
    "ai": "application/postscript",
    "rtf": "application/rtf",
    "m3u8": "application/vnd.apple.mpegurl",
    "xls": "application/vnd.ms-excel",
    "eot": "application/vnd.ms-fontobject",
    "ppt": "application/vnd.ms-powerpoint",
    "wmlc": "application/vnd.wap.wmlc",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "7z": "application/x-7z-compressed",
    "cco": "application/x-cocoa",
    "jardiff": "application/x-java-archive-diff",
    "jnlp": "application/x-java-jnlp-file",
    "run": "application/x-makeself",
    "pl": "application/x-perl",
    "pm": "application/x-perl",
    "prc": "application/x-pilot",
    "pdb": "application/x-pilot",
    "rar": "application/x-rar-compressed",
    "rpm": "application/x-redhat-package-manager",
    "sea": "application/x-sea",
    "swf": "application/x-shockwave-flash",
    "sit": "application/x-stuffit",
    "tcl": "application/x-tcl",
    "tk": "application/x-tcl",
    "der": "application/x-x509-ca-cert",
    "pem": "application/x-x509-ca-cert",
    "crt": "application/x-x509-ca-cert",
    "xpi": "application/x-xpinstall",
    "xhtml": "application/xhtml+xml",
    "xspf": "application/xspf+xml",
    "zip": "application/zip",
    "bin": "application/octet-stream",
    "exe": "application/octet-stream",
    "dll": "application/octet-stream",
    "deb": "application/octet-stream",
    "dmg": "application/octet-stream",
    "iso": "application/octet-stream",
    "img": "application/octet-stream",
    "msi": "application/octet-stream",
    "msp": "application/octet-stream",
    "msm": "application/octet-stream",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "kar": "audio/midi",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
    "m4a": "audio/x-m4a",
    "ra": "audio/x-realaudio",
    "3gpp": "video/3gpp",
    "3gp": "video/3gpp",
    "ts": "video/mp2t",
    "mp4": "video/mp4",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "mov": "video/quicktime",
    "webm": "video/webm",
    "flv": "video/x-flv",
    "m4v": "video/x-m4v",
    "mng": "video/x-mng",
    "asx": "video/x-ms-asf",
    "asf": "video/x-ms-asf",
    "wmv": "video/x-ms-wmv",
    "avi": "video/x-msvideo"
]

internal func MimeType(ext: String?) -> String {
    let lowercase_ext: String = ext!.lowercased()
    if ext != nil && mimeTypes.contains(where: { $0.0 == lowercase_ext }) {
        return mimeTypes[lowercase_ext]!
    }
    return DEFAULT_MIME_TYPE
}

extension NSURL {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}
