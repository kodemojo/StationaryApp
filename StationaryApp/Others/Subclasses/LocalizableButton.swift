//
//  LocalizableButton.swift
//  AzamTV
//
//  Created by Isac Joseph on 21/02/19.
//  Copyright © 2019 Isac Joseph. All rights reserved.
//

import UIKit

class LocalizableButton: UIButton
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
        self.setTitle(self.titleLabel?.text?.localized, for: .normal)
    }
}
