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
