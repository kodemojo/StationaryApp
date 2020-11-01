//
//  LocalizableLabel.swift
//  AzamTV
//
//  Created by Isac Joseph on 21/02/19.
//  Copyright © 2019 Isac Joseph. All rights reserved.
//

import UIKit

class LocalizableLabel: UILabel
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit()
    {
        print("Returning \(self.text)")
        self.text = self.text?.localized
    }

}
