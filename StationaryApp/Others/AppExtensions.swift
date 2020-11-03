//
//  AppExtensions.swift
//  StationaryApp
//
//  Created by Isac Joseph on 29/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var localized : String
    {
        get
        {
            if let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj"),let localeBundle = Bundle(path: path)
            {
                let localized =  NSLocalizedString(self, tableName: nil, bundle: localeBundle, value: self, comment: "")
                print("Returning \(localized) for key \(self)")
                return localized
            }
            
            print("Returning \(self) for key \(self)")
            return NSLocalizedString(self, comment: "")
        }
    }
    
}





//
//if let url = Bundle.main.url(forResource: "abc", withExtension: ".txt") {
//    let text2 = try? String(contentsOf: url, encoding: .utf8)
//    
//    let regex = try? NSRegularExpression(pattern: "text=\"(.*?)\"")
//    let results = regex!.matches(in: text2!,
//                                range: NSRange(text2!.startIndex..., in: text2!))
//    
//    var mainString = ""
//    
//    for rang in results {
//        var s = String(text2![Range(rang.range, in: text2!)!])
//        s = s.replacingOccurrences(of: "text=", with: "")
//        s = s.replacingOccurrences(of: "\"", with: "")
//        mainString = mainString + "\n" + s
//    }
//    
//    print(mainString)
//    
//    
//}
