//
//  TransportNearestCell.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 18.02.17.
//
//

import UIKit

class TransportNearestCell: UITableViewCell {
    @IBOutlet var startTimeLabel: UILabel?
    @IBOutlet var separatorLabel: UILabel?
    @IBOutlet var endTimeLabel: UILabel?
    @IBOutlet var leftTimeLabel: UILabel?
    
    func show(_ item: NearestTransportItem) {
        separatorLabel?.textColor = UIColor.lightGray
        endTimeLabel?.textColor = UIColor.lightGray
        
        startTimeLabel?.text = item.startTime.hmValue()
        endTimeLabel?.text = item.endTime.hmValue()
        
        if item.startTime.isToday {
            let seconds = lround(item.interval)
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            if hours == 0 {
                leftTimeLabel?.text = "Через\n\(minutes) мин."
                if minutes < 30 {
                    leftTimeLabel?.textColor = Style.greenColor
                } else {
                    leftTimeLabel?.textColor = UIColor.darkText
                }
            } else {
                leftTimeLabel?.text = "Через\n\(hours) ч. \(minutes) мин."
                leftTimeLabel?.textColor = UIColor.lightGray
            }
            
        } else if item.startTime.isTomorrow {
            leftTimeLabel?.text = "Завтра"
            leftTimeLabel?.textColor = UIColor.lightGray
        }
    }

}
