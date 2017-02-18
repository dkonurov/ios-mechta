//
//  ScheduleCell.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 18.02.17.
//
//

import UIKit

class TransportScheduleCell: UITableViewCell {

    @IBOutlet var hourLabel: UILabel?
    @IBOutlet var minutesView: UIView!
    
    func show(scheduleItem item: ScheduleItem) {
        hourLabel?.text = item.hour
        
        minutesView.subviews.forEach() { $0.removeFromSuperview() }
        
        var x: CGFloat = 0
        let margin: CGFloat = 10
        let fontSize: CGFloat = 15
        
        for i in 0 ..< item.minutes.count {
            let minute = item.minutes[i]
            
            let label = UILabel()
            label.text = minute.workingDaysOnly ? "\(minute.minute)*" : minute.minute
            label.textColor = Style.darkColor
            label.textAlignment = .left
            label.font = label.font.withSize(fontSize)
            label.sizeToFit()
            
            let width = label.frame.width
            let height = minutesView!.frame.height
            
            minutesView.addSubview(label)
            label.frame = CGRect(x: x, y: 0, width: width, height: height)
            
            x = x + width + margin
            
        }
    }

}
