//
//  AppGlobals.swift
//  StationaryApp
//
//  Created by Isac Joseph on 29/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

/*
 * Returns app language
 */
var appLanguage: String
{
    get {
        var lan = "en"
        if let langaugeArray = UserDefaults.standard.object(forKey: Constant.UserDefaultKeys.appleLanguages) as? [String] {
            if let language = langaugeArray.first {
                if language == "ar" {
                    lan = language
                }
            }
        }
        return lan
    }
    
    set {
        UserDefaults.standard.set([newValue], forKey: Constant.UserDefaultKeys.appleLanguages)
    }
}

var languageParameter: String {
    return appLanguage == "en" ? "default" : "arabic"
}
