//
//  UITableView+Extension.swift
//  GetAFix
//
//  Created by Anup Kumar on 5/9/18.
//  Copyright © 2018 Mohd Arsad. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func showBackgroundMsg(msg : String)  {
//        var frame = self.bounds
//        frame.size.height -= 50
        let label = UILabel(frame: self.bounds)
        label.text = msg
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        self.backgroundView = label
        self.separatorStyle = .none
        
    }
}
extension UITableViewCell {
    func setCellDropShadow(cornerRadius : CGFloat) {
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:(self.bounds), cornerRadius: cornerRadius).cgPath
    }
}


extension Date {
    
    private func hourCalculation() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        guard let expDate = dateFormatter.date(from: dateFormatter.string(from: self)) else {
            return  "0 secs"
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .weekday, .month, .year, .hour, .minute,.second], from: expDate, to: Date())
        var timeStr = ""
        if(components.year != 0) {
            timeStr = "\(components.year ?? 1) \((components.year == 1) ?  "year" : "years")"
        }
        else if(components.month != 0) {
            timeStr = "\(components.month ?? 1) \((components.month == 1) ?  "month" : "months")"
        }
        else if(components.weekday != 0) {
            timeStr = "\(components.weekday ?? 1) \((components.weekday == 1) ?  "week" : "weeks")"
        }
        else if(components.day != 0) {
            timeStr = "\(components.day ?? 1) \((components.day == 1) ?  "day" : "days")"
        }
        else if(components.hour != 0) {
            timeStr = "\(components.hour ?? 1) \((components.hour == 1) ?  "hour" : "hours")"
        }
        else if(components.minute != 0) {
            timeStr = "\(components.minute ?? 1) \((components.minute == 1) ?  "min" : "mins")"
        }
        else if(components.second != 0) {
            timeStr = "\(components.second ?? 1) \((components.second == 1) ?  "sec" : "secs")"
        }
        return timeStr
    }
}
