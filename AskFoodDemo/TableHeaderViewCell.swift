//
//  TableHeaderViewCell.swift
//  Ask Food
//
//  Created by Colearo on 16/1/26.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
class TableHeaderViewCell:UITableViewCell
{
    var height_:CGFloat = 28.0
    var label:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
    }
    
    class func getHeight() -> CGFloat
    {
        return 28.0
    }
    
    func setDate(value:NSDate)
    {
        self.height_  = 28.0
        self.backgroundColor=Color.clear
        let text =  formatDate(value)
        
        if (self.label != nil)
        {
            self.label.text = text
            return
        }
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.label = UILabel(frame:CGRectMake(CGFloat(0), CGFloat(0), self.frame.size.width, height_))
        
        self.label.text = text
        self.label.font = UIFont.boldSystemFontOfSize(9)
        
        self.label.textAlignment = NSTextAlignment.Center
        self.label.shadowOffset = CGSizeMake(0, 1)
        self.label.shadowColor = UIColor.whiteColor()
        
        self.label.textColor = UIColor.darkGrayColor()
        
        self.label.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.label)
    }
    func formatDate(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        
        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
        let isToday = calendar.isDateInToday(date)
        let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*60*60), toDate: date, toUnitGranularity: NSCalendarUnit.Day) == NSComparisonResult.OrderedAscending)
        
        if last18hours || isToday {
            dateFormatter.dateFormat = "a HH:mm"
        } else if isLast7Days {
            dateFormatter.dateFormat = "MM月dd日 a HH:mm EEEE"
        } else {
            dateFormatter.dateFormat = "YYYY年MM月dd日 a HH:mm"
            
        }
        return dateFormatter.stringFromDate(date)
    }
}
