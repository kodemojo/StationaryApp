//
//  LocalizableTabBarItem.swift
//  AzamTV
//
//  Created by Isac Joseph on 21/02/19.
//  Copyright © 2019 Isac Joseph. All rights reserved.
//

import UIKit

class LocalizableTabBarItem: UITabBarItem
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit()
    {
        if let title = self.title
        {
            self.title =  title.localized
        }
        
    }
}
